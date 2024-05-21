import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hihealth/models/user_doctor.dart';
import 'package:hihealth/models/user_patient.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance.collection('hihealth').doc('users');
  final _storage = FirebaseStorage.instance.ref();

  Future<String> registerUser({required String email, required String password}) async{
    return await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    ).then(
      (value) => value.user!.uid
    );
  }

  Future<String> loginUser({required String email, required String password}) async{
    return await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password
    ).then(
      (value) => value.user!.uid
    );
  }

  Future<bool> checkUserDoctorFirestore({required String uid}) async{
    return await _firestore.get().then(
      (value) {
        List list; 
        list = value.data()!['doctor'];
        return list.contains(uid);
      }
    );
  }

  Future<bool> checkUserPatientFirestore({required String uid}) async{
    return await _firestore.get().then(
      (value) {
        List list; 
        list = value.data()!['patient'];
        return list.contains(uid);
      }
    );
  }

  Future setDoctorProfileFirestore(UserDoctor doctor, String uid) async{
    await _firestore.update({'doctor': FieldValue.arrayUnion([uid])});
    await _firestore.collection('doctor_profiles').doc(uid).set(
      {
        'name': doctor.name,
        'imageurl': doctor.imageUrl,
        'specialization': doctor.specialization,
        'company': doctor.company,
        'languages': doctor.languages,
        'about': doctor.about,
        'isonline': true
      }
    );
  }

    Future setPatientProfileFirestore(UserPatient patient, String uid) async{
      await _firestore.update({'patient': FieldValue.arrayUnion([uid])});
    await _firestore.collection('patient_profiles').doc(uid).set(
      {
        'name': patient.name,
        'imageurl': patient.imageUrl,
        'language': patient.language,
        'isonline': true
      }
    );
  }

  Future<String> uploadImageStorage(String uid, File file) async{
    TaskSnapshot x = await _storage.child('hihealth_images/$uid').putFile(file).catchError((error){
      throw (error as FirebaseException).code;
    });
    if (x.state == TaskState.success) {
      return x.ref.getDownloadURL();
    } else {
      throw Exception('Failed to upload File');
    }
  }

  Future toggleOnlineDoctor(String uid, bool isonline) async{
    await _firestore.collection('doctor_profiles').doc(uid).update(
      {'isonline': isonline}
    );
  }

  Future toggleOnlinePatient(String uid, bool isonline) async{
    await _firestore.collection('patient_profiles').doc(uid).update(
      {'isonline': isonline}
    );
  }

  Stream<UserDoctor> beginDoctorProfileStream(String uid){
    return _firestore.collection('doctor_profiles').doc(uid).snapshots().map(
      (event) {
        final data = event.data()!;
        return UserDoctor(
        about: data['about'],
        uid: event.id, 
        languages: data['languages'], 
        isonline: data['isonline'],
        name: data['name'], 
        specialization: data['specialization'], 
        company: data['company'], 
        imageUrl: data['imageurl']
        );
      }
    );
  }

  Stream<UserPatient> beginPatientProfileStream(String uid){
    return _firestore.collection('patient_profiles').doc(uid).snapshots().map(
      (event) {
        final data = event.data()!;
        return UserPatient(
        language: data['language'], 
        name: data['name'], 
        imageUrl: data['imageurl']
        );
      }
    );
  }

  Stream<List<UserDoctor>> streamAllDoctors() {
    return _firestore.collection('doctor_profiles').snapshots().map((event) {
      return event.docs.map((e) {
        var data = e.data();
        return UserDoctor(
        about: data['about'], 
        uid: e.id,
        languages: data['languages'], 
        isonline: data['isonline'],
        name: data['name'], 
        specialization: data['specialization'], 
        company: data['company'], 
        imageUrl: data['imageurl']
        );
      }).toList();
    });
  }

  Stream<String> streamVideoChatToken(){
    return _firestore.snapshots().map((event) => event.get('videotoken'));
  }

  
}