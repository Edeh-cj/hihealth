import 'package:flutter/material.dart';
import 'package:hihealth/models/user_doctor.dart';
import 'package:hihealth/providers/all_chat_notifier.dart';
import 'package:hihealth/providers/single_chat_notifier.dart';
import 'package:hihealth/screens/patient/chat_page.dart';
import 'package:hihealth/screens/patient/dashboard.dart';
import 'package:hihealth/utilities/app_colors.dart';
import 'package:hihealth/utilities/app_functions.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_notifier.dart';
import '../../providers/call_notifier.dart';
import '../../utilities/locale_string_function.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.doctor});
  final UserDoctor doctor;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isloading = false;
  toggleLoading(bool value){
    setState(() {
      isloading = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: arrowBack(context),
        ),
        title: Text(
          widget.doctor.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _listCard(widget.doctor),
            const SizedBox(height: 16,),
            _ratingCard(),
            const SizedBox(height: 16,),
            _aboutBox(widget.doctor.about),
            const SizedBox(height: 16,),
            const SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Working Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text(
                    'Mon-Fri, 10:00AM - 4:00PM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async{
                toggleLoading(true);
                await context.read<AllChatNotifier>().initiateChat(
                  context.read<AuthNotifier>().uid,
                  widget.doctor.uid                     
                ).then( (value) => Navigator.pushReplacement(
                    context, MaterialPageRoute(
                      builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(create: (_)=> SingleChatNotifier(
                            userid: context.read<AuthNotifier>().uid, 
                            participantuid: widget.doctor.uid, 
                            chatId: value.chatid
                          ),),
                          ChangeNotifierProvider(create: (_)=> CallNotifier(
                            uid: context.read<AuthNotifier>().uid)
                          )
                        ],
                        child: const ChatPage(),
                      )
                    )
                  )
                ).catchError((error){
                  toggleLoading(false);
                  AppFunctions.showSnackbar(context, error);
                });
              },
              child: _messageButton(isloading)
            ),          
          ],
        ),
      ),
    );
  }

  Widget _aboutBox(String text) => SizedBox(
    width: double.maxFinite,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Doctor',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),
        ),
        const SizedBox(height: 4,),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              
              fontWeight: FontWeight.w300
            ),
          ),
        )
      ],
    ),
  );

  Container _listCard(UserDoctor doctor) {
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    doctor.imageUrl
                  )
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
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17.5
                    ),
                  ),
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
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: context.watch<AuthNotifier>().isOnline? AppColors.green: AppColors.offlineGrey,
                      ),
                      const SizedBox(width: 3,),
                      Text(
                        context.watch<AuthNotifier>().isOnline? 'Online' : 'Offline',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 8.7
                        ),
                      ),
                      // const Spacer()
                      
                      const SizedBox(height: 24,)
                      
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

  Widget _messageButton(bool isloading)=> Center(
    child: Container(
      width: double.maxFinite,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isloading? AppColors.borderGrey : AppColors.green,
      ),
      child: Center(
        child: Text(
          localeTranslation(
            'Message', 
            stringToLanguage(
              context.read<AuthNotifier>().userPatient?.language
            )
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    ),
  );

  Widget _ratingCard()=> Container(
    height: 158,
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.83),
      border: Border.all(color: AppColors.borderGrey)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.lightGreen,
              ),
              child: Icon(
                Icons.message,
                color: AppColors.green,
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            const SizedBox(
              height: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5000+',
                    style: TextStyle(
                      fontSize: 13.66,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Patients',
                    style: TextStyle(
                      fontSize: 13.66,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.lightGreen,
              ),
              child: Icon(
                Icons.message,
                color: AppColors.green,
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            const SizedBox(
              height: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '15+',
                    style: TextStyle(
                      fontSize: 13.66,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Years Experience',
                    style: TextStyle(
                      fontSize: 13.66,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.lightGreen,
              ),
              child: Icon(
                Icons.message,
                color: AppColors.green,
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            const SizedBox(
              height: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5000+',
                    style: TextStyle(
                      fontSize: 13.66,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Patients',
                    style: TextStyle(
                      fontSize: 13.66,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        
      ],
    ),
  );

  Widget arrowBack(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: ()=>Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => CallNotifier(
                    uid: context.read<AuthNotifier>().uid
                  )
                )
              ],
              child: const DashBoard()
            )
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

}