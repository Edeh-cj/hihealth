import 'package:flutter/material.dart';
import 'package:hihealth/models/user_doctor.dart';
import 'package:hihealth/providers/auth_notifier.dart';
import 'package:hihealth/screens/patient/category_page.dart';
import 'package:hihealth/screens/patient/detail_page.dart';
import 'package:hihealth/utilities/app_colors.dart';
import 'package:hihealth/utilities/app_textstyles.dart';
import 'package:hihealth/utilities/locale_string_function.dart';
import 'package:provider/provider.dart';
import '../../models/specializations.dart';
import '../../providers/call_notifier.dart';
import '../video_call_recieve_page.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    context.read<AuthNotifier>().beginPatientProfileStream();
    context.read<AuthNotifier>().beginStreamAllDoctors();
    context.read<CallNotifier>().beginCallStream();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            toolbarHeight: 120,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Image.asset('assets/images/hilogo.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CircleAvatar(
                        radius: 13.5,
                        backgroundImage: context.watch<AuthNotifier>().userPatient == null? null 
                        : NetworkImage(context.read<AuthNotifier>().userPatient!.imageUrl)
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,),
                  child: TextField(              
                    decoration: InputDecoration(
                      constraints: BoxConstraints.tight(const Size(double.maxFinite, 50)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color.fromRGBO(137, 138, 141, 1)
                      ),
                      fillColor: AppColors.lightGrey,
                      filled: true,
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(137, 138, 141, 1)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,                  
                      )
                    ),
                  ),
                ),
              ],
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24,),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localeTranslation(
                            'Specialist Doctors', 
                            stringToLanguage(
                              context.read<AuthNotifier>().userPatient?.language
                            )
                          ) ,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20
                          ),
                        ),
                        Text(
                          localeTranslation(
                            'See All', 
                            stringToLanguage(
                              context.read<AuthNotifier>().userPatient?.language
                            )
                          ),
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _categoryCard(Specialization.dummy(Colors.red, 'Cardio Specialist')),
                        _categoryCard(Specialization.dummy(Colors.green, 'Dental Specialist')),
                        _categoryCard(Specialization.dummy(Colors.blue, 'Pathology')),
                        _categoryCard(Specialization.dummy(Colors.lime, 'Pediatrics')),
                
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localeTranslation(
                            'Online Doctors', 
                            stringToLanguage(
                              context.read<AuthNotifier>().userPatient?.language
                            )
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20
                          ),
                        ),
                        Text(
                          localeTranslation(
                            'See All', 
                            stringToLanguage(
                              context.read<AuthNotifier>().userPatient?.language
                            )
                          ),
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 230,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: context.watch<AuthNotifier>().doctors.map(
                        (e) => GestureDetector(
                          onTap: ()=> Navigator.pushReplacement(
                            context, MaterialPageRoute(
                              builder: (context)=>  DetailPage(doctor: e,)
                            )
                          ),
                          child: _doctorCard(e),
                        )).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localeTranslation(
                            'Recommendations', 
                            stringToLanguage(
                              context.read<AuthNotifier>().userPatient?.language
                            )
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20
                          ),
                        ),
                        Text(
                          localeTranslation(
                            'See All', 
                            stringToLanguage(
                              context.read<AuthNotifier>().userPatient?.language
                            )
                          ),
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 230,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: context.watch<AuthNotifier>().doctors.map(
                        (e) => GestureDetector(
                          onTap: ()=> Navigator.pushReplacement(
                            context, MaterialPageRoute(
                              builder: (context)=>  DetailPage(doctor: e,)
                            )
                          ),
                          child: _doctorCard(e),
                        )).toList(),
                    ),
                  ),
                ),       
          
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
  Widget _doctorCard(UserDoctor doctor)=> Center(
    child: Container(
      height: 207,
      width: 160,
      margin: const EdgeInsets.only(right: 20, top: 10, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromRGBO(234, 234, 234, 1))      
      ),
      child: Column(
        children: [
          Expanded(
            flex: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
                ),
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
            flex: 6,
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    doctor.name,
                    style: AppTextStyles.doctorCardName,
                  ),
                  Text(
                    doctor.specialization,
                    style: AppTextStyles.doctorCardDetail,
                  )
                ],
              ),
            )
          )
        ],
      ),
    ),
  );

  Widget _categoryCard (Specialization spec)=> Center(
    child: GestureDetector(
      onTap: ()=> Navigator.push(
        context, MaterialPageRoute(
          builder: (context)=> const CategoryPage()
        )
      ),
      child: Container(
        height: 187,
        width: 157,
        margin: const EdgeInsets.only( right: 20, top: 8),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              spec.color,
              spec.color.shade800
            ]
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              spec.imageUrl,
            ),
            SizedBox(
              height: 36,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    spec.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13
                    ),
                  ),
                  Text(
                    '${spec.count}Doctors',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 8.8,
                    ),
                  ),
      
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

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