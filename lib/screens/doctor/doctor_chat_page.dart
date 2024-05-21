import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hihealth/providers/auth_notifier.dart';
import 'package:hihealth/providers/call_notifier.dart';
import 'package:hihealth/providers/single_chat_notifier.dart';
import 'package:hihealth/screens/doctor/doctor_dashboard.dart';
import 'package:hihealth/screens/video_call_initiate_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/app_functions.dart';
import '../video_call_recieve_page.dart';

class DoctorChatPage extends StatefulWidget {
  const DoctorChatPage({super.key,});

  @override
  State<DoctorChatPage> createState() => _DoctorChatPageState();
}

class _DoctorChatPageState extends State<DoctorChatPage> {

  final _messageController = TextEditingController();
  @override
  void initState() {
    context.read<SingleChatNotifier>().beginMessageStream();
    context.read<SingleChatNotifier>().beginIsPatientOnline();
    context.read<SingleChatNotifier>().getPatientInfo();
    context.read<CallNotifier>().beginCallStream();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
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
            actions: [
              _actionIcon(
                () {
                  context.read<CallNotifier>().initiateCall(
                    context.read<AuthNotifier>().userDoctor.name, 
                    context.read<SingleChatNotifier>().participantuid
                  );
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const VideoCallInitiatePage()
                    )
                  );
                }, 
                Icons.video_call
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _listCard(
                  imageUrl: context.watch<SingleChatNotifier>().imageUrl, 
                  name: context.watch<SingleChatNotifier>().participantName, 
                  isOnline: context.watch<SingleChatNotifier>().isParticipantOnline
                ),
                const SizedBox(height: 16,),
                Expanded(
                  child: FractionallySizedBox(
                    child: ListView(
                      controller: context.read<SingleChatNotifier>().scrollController,
                      children: context.watch<SingleChatNotifier>().messages.map(
                        (e) => e.isurl? imageMessageBubble( 
                          e.sender != context.read<SingleChatNotifier>().participantuid,
                          e.messageNote) 
                          : _messageBubble(
                          e.sender != context.read<SingleChatNotifier>().participantuid,
                          e.messageNote                      
                        ) 
                      ).toList()
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
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
                  ),
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
          ),
        ),
      ],
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


  Container _listCard({ required String? imageUrl, required String? name, required bool isOnline}) {
    var isOnline = context.watch<SingleChatNotifier>().isParticipantOnline;
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
            child: imageUrl == null? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: AppColors.lightGrey
              ),
            )
            :Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageUrl)
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
                    name?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17.5
                    ),
                  ),
                  
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: isOnline? AppColors.green: AppColors.offlineGrey,
                      ),
                      Text(
                        isOnline? 'Online': 'Offliine',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 9
                        ),
                      )
                    ],
                  ),                 
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
        onTap: ()=>Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => CallNotifier(uid: context.read<AuthNotifier>().uid))
              ],
              child: const DoctorDashBoard())
          )
        ),
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