import 'package:flutter/material.dart';

import '../repository/call_repository.dart';

class CallNotifier extends ChangeNotifier {
  final repo = CallRepository();
  bool isCallActive = false;
  String callerName = '';
  final String uid;
  CallNotifier({required this.uid});

  beginCallStream(){
    repo.streamVideoCallAlert().listen((event) {
      var n = event.get('name');
      var c = event.get('uid');
      if (c == uid) {
        isCallActive = true;
        callerName = n;
        notifyListeners();
      } 
    });
  }

  Future setFirestoreCallNull() async{
    await repo.setFirestoreCallNull();
  }

  Future initiateCall(String callerName, String recieveruid) async{
    await repo.initiateCall(callersName: callerName, recieveruid: recieveruid);
  }

  setCallActiveFalse() {
    isCallActive = false;
    notifyListeners();
  }
  setCallActiveTrue() {
    isCallActive = true;
    notifyListeners();
  }
}