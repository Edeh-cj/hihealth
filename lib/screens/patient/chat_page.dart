import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hihealth/models/user_doctor.dart';
import 'package:hihealth/providers/auth_notifier.dart';
import 'package:hihealth/providers/single_chat_notifier.dart';
import 'package:hihealth/screens/patient/dashboard.dart';
import 'package:hihealth/utilities/app_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/call_notifier.dart';
import '../../utilities/app_colors.dart';
import '../video_call_initiate_page.dart';
import '../video_call_recieve_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key,});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    context.read<SingleChatNotifier>().beginDoctorInfoStream();
    context.read<SingleChatNotifier>().beginMessageStream();
    context.read<CallNotifier>().beginCallStream();
    super.initState();
  }

  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserDoctor? doctor = context.watch<SingleChatNotifier>().chatUser;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: _arrowBack(context),
            ),
            title: Text(
              doctor == null? '-' : doctor.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),
            ),        
            actions: [
              _actionIcon(() {
                  context.read<CallNotifier>().initiateCall(
                    context.read<AuthNotifier>().userPatient!.name, 
                    context.read<SingleChatNotifier>().participantuid
                  );
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const VideoCallInitiatePage()
                    )
                  );
                }, Icons.video_call),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _listCard(doctor),
                const SizedBox(height: 16,),
                Expanded(
                  child: FractionallySizedBox(
                    child: ListView(
                      controller: context.read<SingleChatNotifier>().scrollController,
                      children: context.watch<SingleChatNotifier>().messages.map(
                        (e) => e.isurl? imageMessageBubble(
                          e.sender != context.read<SingleChatNotifier>().participantuid,
                          e.messageNote) : _messageBubble(
                          e.sender != context.read<SingleChatNotifier>().participantuid,
                          e.messageNote                      
                        ) 
                      ).toList(),
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _textField(context),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _callCard(
            context.watch<CallNotifier>().isCallActive,
            context.watch<CallNotifier>().callerName
          )
        ),
      ],
    );
  }

  TextField _textField(BuildContext context) {
    return TextField(
      onChanged: (value) {
          setState(() {});
      },
      controller: _messageController,
      decoration: InputDecoration(
        constraints: BoxConstraints.tight(
          const Size(double.maxFinite, 57)
        ),
        hintText: 'Message',
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12
        ),
        suffixIcon: GestureDetector(
          onTap: () async{
            if (_messageController.text.isNotEmpty 
              && context.read<SingleChatNotifier>().isMessageLoading == false) {
              FocusManager.instance.primaryFocus?.unfocus();
              context.read<SingleChatNotifier>().toggleMessageLoading(true);
              await context.read<SingleChatNotifier>().sendMessage(_messageController.text).then((value){
                setState(() {
                  context.read<SingleChatNotifier>().toggleMessageLoading(false);
                });
              }).catchError((error){
                setState(() {
                  context.read<SingleChatNotifier>().toggleMessageLoading(false);
                });
                AppFunctions.showSnackbar(context, error.toString());
              });
            } else{
              var x = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (x != null) {
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context, 
                  builder: (context) => Center(
                    child: Stack(
                      children: [
                        Center(child: Image.file(File(x.path))),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: FloatingActionButton(
                              onPressed: ()async {
                                _toggleMessageLoading(true);
                                Navigator.pop(context);
                                await _sendFileMessage(File(x.path)).then(
                                  (value) {
                                    _toggleMessageLoading(false);
                                  }
                                );
                              },
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.send,
                                color: AppColors.green,
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                  )
                );
              }
            }
            _messageController.clear();
          },
          child: Icon(
            _messageController.text.isEmpty? Icons.attach_file : Icons.send,
            color: context.watch<SingleChatNotifier>().isMessageLoading? AppColors.borderGrey : AppColors.green,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.borderGrey)
        )
      ),
    );
  }

  Future<dynamic> _sendFileMessage(File file) async{
    await context.read<SingleChatNotifier>().sendFileMessage(file);
  }

  _toggleMessageLoading(bool value){
    context.read<SingleChatNotifier>().toggleMessageLoading(value);
  }

  Widget _messageBubble(bool isFromUser, String message)=> Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: SizedBox(
      width: double.maxFinite,
      child: Align(
        alignment: isFromUser? Alignment.centerRight : Alignment.centerLeft,
        child: SizedBox(
          width: 0.59* MediaQuery.of(context).size.width,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: isFromUser? AppColors.green : AppColors.lightGrey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 10,
                  color: isFromUser? Colors.white : Colors.black,
                  fontWeight: FontWeight.w400
                ),            
              ),
            ),
          ),
        ),
      )
    ),
  );

  Widget imageMessageBubble(bool isFromUser, String url)=> Align(
    alignment: isFromUser? Alignment.centerRight : Alignment.centerLeft,
    child: GestureDetector(
      onTap: () => showDialog(
        context: context, 
        builder: (context) => Center(
          child: Image.network(url)
        )
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints.loose(const Size(150, 150)),
        child: Image.network(url)
      ),
    ),
  );
  Container _listCard(UserDoctor? doctor) {
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
            child: Container(
              decoration: doctor== null? BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: AppColors.borderGrey
              )
              :BoxDecoration(
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
              padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor == null? '-' : doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17.5
                    ),
                  ),
                  Text(
                    doctor == null ? '-' 
                      :'${doctor.specialization} - ${doctor.company}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.5
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: context.watch<AuthNotifier>().isOnline? AppColors.green: AppColors.offlineGrey,
                      ),
                      const SizedBox(width: 3,),
                      Text(
                        (doctor == null ? true : doctor.isonline)? 'Online' : 'Offline',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 8.7
                        ),
                      ),
                      
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
  
  Widget _arrowBack(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (context)=> CallNotifier(uid: context.read<AuthNotifier>().uid))
                ],
                child: const DashBoard())
            )
          );
        },
        child: Container(
          width: 33,
          height: 33,
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            borderRadius: BorderRadius.circular(3.44)
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _actionIcon(Function() function, IconData iconData) {
    return Center(
      child: GestureDetector(
        onTap: function,
        child: Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            borderRadius: BorderRadius.circular(18.8)
          ),
          child: Center(
            child: Icon(
              iconData,
              size: 20,
              color: AppColors.green,
            ),
          ),
        ),
      ),
    );
  }

  _callCard(bool isVissible, String name)=> Visibility(
    visible: isVissible,
    child: Material(
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
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) {
                        context.read<CallNotifier>().setFirestoreCallNull();
                        return const VideoCallRecievePage();
                      }
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
    ),
  );

  Widget _button(Color color,String text, Function() funt) {
    
    return GestureDetector(
      onTap:funt,
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
}