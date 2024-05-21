import 'package:flutter/material.dart';
import 'package:hihealth/models/user_doctor.dart';
import 'package:hihealth/providers/all_chat_notifier.dart';
import 'package:hihealth/providers/auth_notifier.dart';
import 'package:hihealth/repository/chat_repository.dart';
import 'package:hihealth/utilities/app_colors.dart';
import 'package:provider/provider.dart';

import '../../models/chat.dart';
import '../../providers/call_notifier.dart';
import '../../providers/single_chat_notifier.dart';
import '../video_call_recieve_page.dart';
import 'doctor_chat_page.dart';

class DoctorDashBoard extends StatefulWidget {
  const DoctorDashBoard({super.key});

  @override
  State<DoctorDashBoard> createState() => _DoctorDashBoardState();
}

class _DoctorDashBoardState extends State<DoctorDashBoard> {
  @override
  void initState() {
    context.read<AuthNotifier>().beginDoctorProfileStream();
    context.read<AllChatNotifier>().beginChatStream(context.read<AuthNotifier>().uid);
    context.read<CallNotifier>().beginCallStream();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24,),
                  _doctorCard(context.watch<AuthNotifier>().userDoctor),
                  const SizedBox(height: 24,),
                  Expanded(
                    child: FractionallySizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chats',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Expanded(child: FractionallySizedBox(
                            child: ListView(
                              children: context.watch<AllChatNotifier>().activeChats.map(
                                (e) => GestureDetector(
                                  onTap: ()=> Navigator.pushReplacement(
                                    context, MaterialPageRoute(
                                      builder: (context)=> MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider(create: (_)=> SingleChatNotifier(
                                            userid: context.read<AuthNotifier>().uid, 
                                            participantuid: e.participants.firstWhere((element) => context.read<AuthNotifier>().uid != element), 
                                            chatId: e.chatid
                                          ),),
                                          ChangeNotifierProvider(create: (_)=> CallNotifier(
                                            uid: context.read<AuthNotifier>().uid)
                                          )
                                        ],
                                        
                                        child: const DoctorChatPage(),
                                      ),
                                    )
                                  ),
                                  child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.76),
                                        side: BorderSide(
                                          color: AppColors.borderGrey,
                                        )
                                      ),
                                      leading: FutureBuilder<Map>(
                                        initialData: {},
                                        future: ChatRepository().getPatientInfo(e.participants.firstWhere((element) => context.read<AuthNotifier>().uid != element)), 
                                        builder: (context, j){
                                          if (j.connectionState == ConnectionState.done && j.hasData) {
                                            return Image.network(j.data!['imageurl']);
                                          } else {
                                            return SizedBox();
                                          }
                                        }
                                      ),
                                      subtitle: Text(
                                        e.messages.isNotEmpty? (e.messages.last as Map<String, dynamic>)['message_note']: '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 7,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black
                                        ),
                                      ),
                                      title: FutureBuilder(
                                        future: ChatRepository().getPatientInfo(e.participants.firstWhere((element) => context.read<AuthNotifier>().uid != element)),
                                        builder: (context, j){
                                          if (j.connectionState == ConnectionState.done && j.hasData) {
                                            return Text(
                                              j.data!['name'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700
                                              ),
                                            );
                                          } else {
                                            return const Text('-');
                                          }
                                        }
                                      ),
                                      trailing: const CircleAvatar(
                                        radius: 10.5,
                                        backgroundColor: Colors.black,
                                        child: Center(
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              ).toList()
                            ) ,
                          ))
                          
                        ],
                      ),
                    )
                  )
                ]
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: _callCard(
                context.watch<CallNotifier>().isCallActive,
                context.watch<CallNotifier>().callerName
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Container _doctorCard(UserDoctor doctor) {
    return Container(
      height: 105,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color.fromRGBO(234, 234, 234, 1))
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: doctor.imageUrl.isEmpty? Image.asset('assets/images/image_holder.png'): Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(doctor.imageUrl)
                )
              ),
            )
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 12, bottom: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17.5
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(
                    '${doctor.specialization} - ${doctor.company}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.5
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        context.watch<AuthNotifier>().isOnline? 'Available':'Unavailable',
                        style: TextStyle(
                          color: context.watch<AuthNotifier>().isOnline? Colors.black : const Color.fromRGBO(196, 196, 196, 1)
                        ),
                      ),
                      const SizedBox(width: 4,),
                      Switch(
                        activeColor: AppColors.green,
                        inactiveTrackColor: const Color.fromRGBO(196, 196, 196, 1),                        
                        value: context.watch<AuthNotifier>().isOnline, 
                        onChanged: (bool value){
                          context.read<AuthNotifier>().toggleOnlineDoctor(value);
                        }
                      )                      
                    ],                  
                  )                  
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  Container _chatCard(Chat chat) {
    return Container(
    height: 53,
    width: double.maxFinite,
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.78),
      border: Border.all(color: AppColors.borderGrey)
    ),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Text('Image here'),
        ),
        Expanded(
          flex: 13,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 6, bottom: 6 ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  // name?? '-',
                  'name here',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w700
                  ),
                ),
                Text(
                  (chat.messages.last as Map<String, dynamic>)['message_note']!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                  ),
                )
              ],
            ),
          )
        ),
        const Expanded(
          flex: 3,
          child: Center(
            child: CircleAvatar(
              radius: 10.5,
              backgroundColor: Colors.black,
              child: Center(
                child: Text(
                  '1',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          )),
      ],
    ),
  );}
  
  _callCard(bool isVissible, String name)=> Visibility(
    visible: isVissible,
    child: Container(
      height: 130,
      width: double.maxFinite,
      color: const Color.fromRGBO(71, 71, 71, 1),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 15
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text(
              'is Calling...',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(158, 158, 158, 1),
                fontSize: 15
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _button(Colors.green, 'Accept', (){
                context.read<CallNotifier>().setFirestoreCallNull();
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> const VideoCallRecievePage()
                  )
                );
                context.read<CallNotifier>().setCallActiveFalse();
              }),
              _button(Colors.red, 'Decline', (){
                context.read<CallNotifier>().setFirestoreCallNull();
                context.read<CallNotifier>().setCallActiveFalse();
              }),
            ],
          )
        ],
      ),
    ),
  );

  Widget _button(Color color, String text, Function() funt)=> GestureDetector(
    onTap: funt,
    child:   Container(
    
      height: 40,
    
      width: 145,
    
      decoration: BoxDecoration(
    
        borderRadius: BorderRadius.circular(10),
    
        color: color
    
      ),
    
      child: Center(
    
        child: Text(
    
          text,
    
          style: const TextStyle(
    
            fontWeight: FontWeight.w600,
    
            fontSize: 15,
    
            color: Colors.white
    
          ),
    
        )
    
      ),
    
    ),
  );
}
