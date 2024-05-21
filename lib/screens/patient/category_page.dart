import 'package:flutter/material.dart';
import 'package:hihealth/models/user_doctor.dart';
import 'package:hihealth/screens/patient/detail_page.dart';
import 'package:hihealth/utilities/app_colors.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_notifier.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          centerTitle: false,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 30.0),
              child: Icon(
                Icons.search,
                color: Colors.black,
                size: 30,
              ),
            )
          ],
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 30,
            ),
          ),
          elevation: 0,
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cardio Specialist',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
                ),
              ),
              Text(
                '212 Doctors',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black
                ),
              )
            ],
          ),
        ),
        body: ListView(
          children: context.watch<AuthNotifier>().doctors.map(
            (e) => GestureDetector(
              onTap: ()=> Navigator.push(
                context, MaterialPageRoute(
                  builder: (context)=>  DetailPage(doctor: e,)
                )
              ),
              child: _listCard(e),
            )).toList(),
        ),
      ),
    );
  }
  Widget _listCard (UserDoctor doctor)=> Container(
    height: 105,
    width: double.maxFinite,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                image: NetworkImage(doctor.imageUrl)
              )
            ),
          )
        ),
        Expanded(
          flex: 5,
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
                    )
                  ],                
                )                
              ],
            ),
          )
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.watch<AuthNotifier>().isOnline? AppColors.lightGreen: AppColors.lightGrey,
              ),
              child: Icon(
                Icons.message,
                color: context.watch<AuthNotifier>().isOnline? AppColors.green: AppColors.offlineGrey,
              ),
            ),
          )
        )
      ],
    ),
  );
}