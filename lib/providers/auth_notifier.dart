import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:hihealth/models/user_doctor.dart';
import 'package:hihealth/models/user_patient.dart';
import 'package:hihealth/repository/auth_repository.dart';

class AuthNotifier extends ChangeNotifier {
  UserPatient? userPatient ;
  UserDoctor userDoctor = UserDoctor.dummy();
  List<UserDoctor> doctors = [];
  bool isOnline = true;
  String uid = 'aaaaa';
  String videoChatToken = '007eJxTYLC';
  final _repo = AuthRepository();

  toggleOnlineDoctor(bool isonline) async{
    isOnline = !isOnline;
    notifyListeners();
    await _repo.toggleOnlineDoctor(uid, isonline);
  }

  toggleOnlinePatient(bool isonline) async{
    isOnline = !isOnline;
    notifyListeners();
    await _repo.toggleOnlinePatient(uid, isonline);
  }

  beginDoctorProfileStream(){
    _repo.beginDoctorProfileStream(uid).listen((event) {
      userDoctor = event;
      notifyListeners();
    });
    _repo.streamVideoChatToken().listen((event) {
      videoChatToken = event;
      notifyListeners();
    });
  }

  beginPatientProfileStream(){
    _repo.beginPatientProfileStream(uid).listen((event) {
      userPatient = event;
      notifyListeners();
    });
    _repo.streamVideoChatToken().listen((event) {
      videoChatToken = event;
      notifyListeners();
    });
  }

  beginStreamAllDoctors(){
    _repo.streamAllDoctors().listen(
      (event) {
        doctors = event;
        notifyListeners();
      });
  }

  Future createDoctorProfile({required File file, required String about, required List<String> languages, required String name, required String specialization, required String company}) async{
    var file_ = await FlutterNativeImage.compressImage(
      file.path,
      quality: 5
    );
    
    String imageUrl = await _repo.uploadImageStorage(uid, File(file_.path));
    UserDoctor doctor = UserDoctor(
      about: about, 
      languages: languages, 
      isonline: true,
      uid: uid,
      name: name, 
      specialization: specialization, 
      company: company, 
      imageUrl: imageUrl
    );
    await _repo.setDoctorProfileFirestore(doctor, uid);
  }

  Future createPatientProfile({required File file, required String language, required String name}) async{
    String imageUrl = await _repo.uploadImageStorage(uid, file);
    UserPatient patient = UserPatient(
      language: language, 
      name: name, 
      imageUrl: imageUrl
    );
    await _repo.setPatientProfileFirestore(patient, uid);
  }

  Future registerUserDoctor({required String name,required String email,required String password}) async{
    await _repo.registerUser(
      email: email,
      password: password
    ).then((value) {
      uid = value;
      return value;
    }).catchError((error){
      throw (error as FirebaseAuthException).code;
    });
  }

  Future registerUserPatient({required String name,required String email,required String password}) async{
    await _repo.registerUser(
      email: email,
      password: password
    ).then((value) {
      uid = value;
      return value;
    }).catchError((error){
      throw (error as FirebaseAuthException).code;
    });
  }

  Future<bool> loginDoctor({required String email, required String password}) async{
    String authuid = await _repo.loginUser(
      email: email,
      password: password
    ).catchError((error){
      throw (error as FirebaseAuthException).code;
    });
    bool isUserFirestoreDoctor = await _repo.checkUserDoctorFirestore(uid: authuid);
    if (isUserFirestoreDoctor) {
      uid = authuid;
    } 
    return isUserFirestoreDoctor;
  }

  Future<bool> loginPatient({required String email, required String password}) async{
    String authuid = await _repo.loginUser(
      email: email,
      password: password
    ).catchError((error){
      throw (error as FirebaseAuthException).code;
    });
    bool isUserFirestorePatient = await _repo.checkUserPatientFirestore(uid: authuid);
    if (isUserFirestorePatient) {
      uid = authuid;
    } 
    return isUserFirestorePatient;
  }
}