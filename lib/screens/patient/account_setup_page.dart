import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hihealth/providers/auth_notifier.dart';
import 'package:hihealth/screens/patient/dashboard.dart';
import 'package:hihealth/utilities/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/call_notifier.dart';
import '../../utilities/app_functions.dart';

class AccountSetupPage extends StatefulWidget {
  const AccountSetupPage({super.key});

  @override
  State<AccountSetupPage> createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends State<AccountSetupPage> {
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _btController = TextEditingController();
  final _cityController = TextEditingController();
  final _birthController = TextEditingController();
  String? languageValue;
  String? genderValue;
  File? file ;
  final _formKey = GlobalKey<FormState>();
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
                _field(_nameController, Icons.person, 'Full Name'),
                _field(_birthController, Icons.date_range_sharp, 'Year of Birth'),
                _field(_genderController, Icons.male, 'Gender'),
                _dropDownField(Icons.male, 'Gender', genderValue, ['Male', 'Female'], (value){setState(() {
                  genderValue = value;
                });}),
                _field(_btController, Icons.bloodtype, 'Blood Group'),
                _field(_cityController, Icons.location_city, 'City'), 
                _dropDownField(Icons.language, 'Preferred Language', languageValue, [
                  'English',
                  'Igbo',
                  'Yoruba',
                  'Hausa'
                ], (value){
                  languageValue = value;
                }),
                const SizedBox(height: 16,),
                GestureDetector(
                  onTap: () async{
                    if (_formKey.currentState!.validate() && file != null && isloading == false ) {
                      _toggleLoading(true);
                      await context.read<AuthNotifier>().createPatientProfile(
                        file: file!, 
                        language: languageValue!, 
                        name: _nameController.text
                      ).then(
                        (value) {
                          AppFunctions.showSnackbar(context, 'Account Setup SuccessFul!');
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(
                              builder: (context)=> ChangeNotifierProvider(
                                create: (BuildContext context)=> CallNotifier(uid: context.read<AuthNotifier>().uid),
                                child: const DashBoard())
                            )
                          );
                        }
                      ).catchError((error){
                        AppFunctions.showSnackbar(context, error);
                      });
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

  Widget _dropDownField(IconData icon, String hintText, String? value, List<String> listvalue, Function(String?) onchange)=> Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      value: value,
      validator: (value){
        if (value == null) {
          return 'Invalid field';
        } 
        return null;
      },
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
      items: listvalue.map((e) => DropdownMenuItem<String>(
        value: e,
        child: Text(e)
      )).toList(), 
      onChanged: onchange,
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
              border: Border.all(color: const Color.fromRGBO(217, 217, 217, 1))
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

  Widget _field(TextEditingController controller, IconData icon, String hintText)=> Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
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
    ),
  );

}