import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../repository/chat_repository.dart';

class AllChatNotifier extends ChangeNotifier {
  final _repo = ChatRepository();
  List<Chat> activeChats = [];

  beginChatStream(String uid){
    _repo.allChatStream(uid).listen((event) { 
      activeChats = event;
      notifyListeners();
    });
  }

  Future<Map> getUserInfo(String uid) async{
    return _repo.getPatientInfo(uid);
  }

  Future<Chat> initiateChat(String userid, String participantuid) async{
    return await _repo.initiateChat(userid, participantuid);
  }
}