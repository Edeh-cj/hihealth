import 'package:cloud_firestore/cloud_firestore.dart';

class CallRepository {
  final callref = FirebaseFirestore.instance.collection('hihealth').doc('video_chat_alert');

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamVideoCallAlert(){
    return callref.snapshots();
  }

  Future initiateCall({required String callersName, required String recieveruid}) async{
    await callref.update({
      'uid': recieveruid,
      'name': callersName
    });
  }

  Future setFirestoreCallNull() async{
    await callref.update({'uid': 'no one'});
  }
  
}