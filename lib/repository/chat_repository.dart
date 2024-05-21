import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hihealth/models/message.dart';
import 'package:hihealth/models/user_doctor.dart';

import '../models/chat.dart';

class ChatRepository {
  final chatsref = FirebaseFirestore.instance.collection('hihealth_chats');
  final userref = FirebaseFirestore.instance.collection('hihealth');
  final _storage = FirebaseStorage.instance.ref();
  
  Stream<List<Chat>> allChatStream(String useruid){
    return chatsref.where('participants', arrayContains: useruid).snapshots().map((event) {
      return event.docs.map((e) {
        final data_ = e.data();
        return Chat(
        chatid: e.id,
        messages: data_['messages'], 
        participants: data_['participants']
        );
      }
      ).toList();
    }
    );
  }

  Stream<List<Message>> streamChatMessages(String chatid){
    return chatsref.doc(chatid).snapshots().map((event) {
      return (event.get('messages')as List).map(
        (e) => Message(
          messageNote: e['message_note'], 
          sender: e['sender'], 
          messageID: e['message_id'], 
          isurl: e['isurl']
          )
        ).toList();
    });
  }

  Future<Map> getPatientInfo(String patientuid) async{
    return await userref.doc('users').collection('patient_profiles').doc(patientuid).get().then((value) => {
      'name' : value.data()?['name'],
      'imageurl' : value.data()?['imageurl'],
      }
    );
  }
  Stream<UserDoctor> streamDoctorInfo(String uid){
    return userref.doc('users').collection('doctor_profiles').doc(uid).snapshots().map(
      (event) {
        Map map = event.data()!;
        return UserDoctor(
          uid: event.id, 
          about: map['about'], 
          languages: map['languages'], 
          name: map['name'],
          isonline: map['isonline'], 
          specialization: map['specialization'], 
          company: map['company'], 
          imageUrl: map['imageurl']
        );
      });
  }
  Stream<bool> isPatientOnlineStream(String patientuid){
    return userref.doc('users').collection('patient_profiles').doc(patientuid).snapshots().map((event) => event.data()!['isonline']);
  }

  Future sendMessage({required String chatId, required bool isurl, required String userid, required String messagenote}) async{
    await chatsref.doc(chatId).update(
      {
        'messages': FieldValue.arrayUnion(
          [{
            'sender': userid,
            'isurl': isurl,
            'message_id': generateRideId(),
            'message_note': messagenote
          }]
        )
      }
    );
  }

  Future<Chat> initiateChat(String userid, String participantuid) async{
    bool isInitiated = await chatsref.where('participants', whereIn: [[participantuid, userid],[userid, participantuid]]).get().then((value) {
      return value.docs.isNotEmpty;
    });
    if(isInitiated){
      return await chatsref.where('participants', whereIn: [[participantuid, userid],[userid, participantuid]]).get().then((value) {
        Map data = value.docs.first.data();
        return Chat(
          chatid: value.docs.first.id, 
          messages: data['messages'], 
          participants: data['participants']
        );
      });
    } else {
      return await chatsref.add(
        {
          'messages': [],
          'participants': [
            participantuid,
            userid
          ]
        }
      ).then((value) async{
        return await value.get().then(
          (v) {            
            return Chat(
              chatid: v.id, 
              messages: v.data()!['messages'], 
              participants: v.data()!['participants']
            );
          }
        );
      }
      );
    }
  }

  Future<String> uploadChatImageStorage(File file) async{
    String uid = generateRideId() + generateRideId();
    TaskSnapshot x = await _storage.child('hihealth_images/$uid').putFile(file).catchError((error){
        throw (error as FirebaseException).code;
      });
      if (x.state == TaskState.success) {
        return x.ref.getDownloadURL();
      } else {
        throw Exception('Failed to upload File');
      }
    }

    String generateRideId (){
      String idStrings = 'abcdefghijklmnopqrstuvwxyz0123456789';
      int randIndex () => Random().nextInt((idStrings.length));
      return idStrings[randIndex()] + idStrings[randIndex()] + idStrings[randIndex()] + idStrings[randIndex()];
    
  }
}