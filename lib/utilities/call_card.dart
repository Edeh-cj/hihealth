import 'package:flutter/material.dart';
import 'package:hihealth/providers/call_notifier.dart';
import 'package:hihealth/screens/video_call_recieve_page.dart';
import 'package:hihealth/utilities/app_colors.dart';
import 'package:provider/provider.dart';

callCard(BuildContext context)=> Container(
  height: 130,
  width: double.maxFinite,
  color: AppColors.borderGrey,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.read<CallNotifier>().callerName,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 15
        ),
      ),
      const Text(
        'is Calling...',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(158, 158, 158, 1),
          fontSize: 15
        ),
      ),
      Row(
        children: [
          _button(Colors.green, 'Accept', (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context)=> const VideoCallRecievePage()
              )
            );
            context.read<CallNotifier>().setCallActiveFalse();
          }),
          _button(Colors.red, 'Decline', (){
            context.read<CallNotifier>().setCallActiveFalse();
          }),
        ],
      )
    ],
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