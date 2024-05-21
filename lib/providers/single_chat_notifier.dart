import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:hihealth/repository/chat_repository.dart';

import '../models/message.dart';
import '../models/user_doctor.dart';

class SingleChatNotifier with ChangeNotifier {
  final _repo = ChatRepository();
  final String chatId ;
  final String participantuid ;
  final String userid;
  String? imageUrl;
  SingleChatNotifier({required this.userid, required this.participantuid, required this.chatId});

  bool isParticipantOnline = false;
  List<Message> messages =[ ]; 
  UserDoctor? chatUser;
  String? participantName;
  bool isMessageLoading = false;
  ScrollController scrollController = ScrollController();

  toggleMessageLoading(bool value){
    isMessageLoading = value;
    notifyListeners();
  }

  Future sendMessage(String messageNote) async{
    toggleMessageLoading(true);
    notifyListeners();
    await _repo.sendMessage(
      chatId: chatId,
      userid: userid,
      isurl: false,  
      messagenote: messageNote
    ).then((value) => toggleMessageLoading(false));
    notifyListeners();
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    notifyListeners();
  }

  Future sendFileMessage(File file) async{
    var file_ = await FlutterNativeImage.compressImage(
      file.path,
      quality: 5
    );
    
    String imageUrl = await _repo.uploadChatImageStorage(File(file_.path));
    
    await _repo.sendMessage(
      chatId: chatId, 
      isurl: true, 
      userid: userid, 
      messagenote: imageUrl
    );
  }

  Future<Map> getPatientInfo(){
    return _repo.getPatientInfo(participantuid).then((value) {
      imageUrl = value['imageurl'];
      participantName = value['name'];
      notifyListeners();
      return value;
    });
  }

  beginDoctorInfoStream(){
    _repo.streamDoctorInfo(participantuid).listen(
      (event) {
        chatUser = event;
      }
    );
  }

  beginMessageStream(){
    _repo.streamChatMessages(chatId).listen((event) {
      messages = event;
      notifyListeners();
    });
  }

  beginIsPatientOnline(){
    _repo.isPatientOnlineStream(participantuid).listen((event) {
      isParticipantOnline = event;
      notifyListeners();
    });
  }

  

}