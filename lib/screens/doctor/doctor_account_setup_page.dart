
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:hihealth/providers/auth_notifier.dart';
import 'package:hihealth/screens/doctor/doctor_dashboard.dart';
import 'package:hihealth/utilities/app_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/call_notifier.dart';
import '../../utilities/app_colors.dart';

class DoctorAccountSetupPage extends StatefulWidget {
  const DoctorAccountSetupPage({super.key});

  @override
  State<DoctorAccountSetupPage> createState() => _DoctorAccountSetupPageState();
}

class _DoctorAccountSetupPageState extends State<DoctorAccountSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _aboutController = TextEditingController();
  final _companyController = TextEditingController();
  String? _languageValue;
  String? _specvalue;
  File? file ;
  bool isloading = false;
  _toggleLoading(bool value){
    setState(() {
      isloading = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 12,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        title: const Text(
          'Account Set-up',
          style: TextStyle(
            fontSize: 21.42,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24,),
                GestureDetector(
                  onTap: () async{
                    var x = await ImagePicker().pickImage(source: ImageSource.gallery);
                    
                    if (x != null) {
                      setState(() {
                        file = File(x.path);
                      });
                    }
                  },
                  child: _imageBox()
                ),
                const SizedBox(height: 24,),
                _field(_nameController, Icons.person, 'Full Name', false),
                _dropDownField(
                  Icons.workspace_premium_rounded, 
                  'Specialization', 
                  [
                    'Cardiologist',
                    'Dental Specialist',
                    'Pediatrics',
                    'Pathology',
                    'Psychiatry'

                  ], 
                  _specvalue,
                  (String? value_) {
                    setState(() {
                      _specvalue = value_;
                    });
                    
                  },
                ),
                _field(_companyController, Icons.work, 'Company', false),
                _field(_aboutController, Icons.info, '', true),
                _field(_cityController, Icons.location_city, 'City', false), 
                _dropDownField(
                  Icons.language, 
                  'Second Language', 
                  [
                    'Hausa',
                    'Igbo',
                    'Yoruba'
                  ],
                  _languageValue,
                  (String? value_) {
                    setState(() {
                      _languageValue = value_;
                    });
                    
                  },
                ),
                const SizedBox(height: 16,),
                GestureDetector(
                  onTap: () async{
                    if (_formKey.currentState!.validate() && file != null && isloading == false) {
                      _toggleLoading(true);
                      await context.read<AuthNotifier>().createDoctorProfile(
                        file: file!, 
                        about: _aboutController.text, 
                        languages: ['English', _languageValue!], 
                        name: _nameController.text, 
                        specialization: _specvalue!, 
                        company: _companyController.text
                      ).catchError((error){
                        AppFunctions.showSnackbar(context, error);
                      }).then((value) {
                        AppFunctions.showSnackbar(context, 'Account Setup SuccessFul!');
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (BuildContext context)=> CallNotifier(uid: context.read<AuthNotifier>().uid),
                              child: const DoctorDashBoard())
                            )
                          );
                        }
                      );
                      _toggleLoading(false);
                    }
                  },
                  child: _continueButton()),
                const SizedBox(height: 32,),
          
                  
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropDownField(IconData icon, String hintText, List<String> valueList, String? value, Function(String?) onchange)=> Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15.64)
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade700,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color.fromRGBO(103, 103, 103, 1),
          fontSize: 12.52
        ),
        fillColor: const Color.fromRGBO(253, 253, 253, 1),
        filled: true
      ),
      value: value,
      validator: (value){
        if (value == null) {
          return 'Invalid field';
        } 
        return null;
      },
      items: List.generate(
        valueList.length, 
        (index) => DropdownMenuItem(
          value: valueList[index],
          child: Text(valueList[index])
        )
      ), 
      onChanged: onchange
    ),
  );

  Widget _continueButton()=> Center(
    child: Container(
      width: double.maxFinite,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isloading == false? AppColors.green : AppColors.borderGrey,
      ),
      child: const Center(
        child: Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    ),
  );

  Widget _imageBox()=> SizedBox(
    height: 140,
    width: 135,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.center,
            height: 130,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13.24),
              border: Border.all(color: const Color.fromRGBO(217, 217, 217, 1)),
              
            ),
            child: (file == null)? Image.asset('assets/images/image_holder.png')
            : Image.file(
              File(file!.path),
              fit: BoxFit.cover,),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.8),
              color: AppColors.green
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 16,
            ),
          ),
        )
      ],
    ),
  );

  Widget _field(TextEditingController controller, IconData icon, String hintText, bool isThreeLine)=> Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller, 
      validator: (value){
        if (value == null || value.isEmpty) {
          return 'Invalid field';
        } else{
          return null;
        }
        
      }, 
      maxLines: isThreeLine? 5 : null,     
      decoration: InputDecoration(
        constraints: BoxConstraints.tight(Size(double.maxFinite, isThreeLine? 150 : 60)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15.64)
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade700,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color.fromRGBO(103, 103, 103, 1),
          fontSize: 12.52
        ),
        fillColor: const Color.fromRGBO(253, 253, 253, 1),
        filled: true
      ),
      
    ),
  );
}