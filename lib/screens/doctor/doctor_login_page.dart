import 'package:flutter/material.dart';
import 'package:hihealth/providers/auth_notifier.dart';
import 'package:hihealth/screens/doctor/doctor_dashboard.dart';
import 'package:hihealth/utilities/app_functions.dart';
import 'package:provider/provider.dart';

import '../../providers/call_notifier.dart';
import '../../utilities/app_colors.dart';

class DoctorLoginPage extends StatefulWidget {
  const DoctorLoginPage({super.key});

  @override
  State<DoctorLoginPage> createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  toggleloading(bool value){
    setState(() {
      isloading = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: GestureDetector(
          onTap: ()=> Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 240,
                  child: Text(
                    'Login to Your Account',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 33.33,
                      color: Colors.black
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                _field(_emailController, Icons.email, 'Enter your Email', false),
                _field(_passwordController, Icons.lock, 'Password', true),
                GestureDetector(
                  onTap: ()=> Navigator.pop(context),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                
                GestureDetector(
                  onTap: () async{
                    if (_formKey.currentState!.validate()) {
                      toggleloading(true);
                      await context.read<AuthNotifier>().loginDoctor(
                        email: _emailController.text, 
                        password: _passwordController.text
                      ).then((value) {
                        if (value) {
                          Navigator.pushReplacement(
                            context,  MaterialPageRoute(
                              builder: (context)=> ChangeNotifierProvider(
                                create: (BuildContext context)=> CallNotifier(uid: context.read<AuthNotifier>().uid),
                                child: const DoctorDashBoard())
                            ) 
                          );
                        } else {
                          AppFunctions.showSnackbar(context, 'User not Found');
                        }
                      }).catchError((error){
                        AppFunctions.showSnackbar(context, error);
                        toggleloading(false);
                      });
                    }
                  },
                  child: _loginButton(isloading)),
                const SizedBox(height: 24,),
                _federationSignup()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _federationSignup()=> Column(
    children: [
      const Row(
        children: [
          Expanded(
            flex: 1,
            child: Divider(
              thickness: 0.8,
              color: Color.fromRGBO(103, 103, 103, 1),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Or Continue with', 
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(103, 103, 103, 1),
                fontWeight: FontWeight.w400,
                fontSize: 12
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: Divider(
              thickness: 0.8,
              color: Color.fromRGBO(103, 103, 103, 1),
            ),
          ),
        ],
      ),
      const SizedBox(height: 24,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/higoogle.png'),
          const SizedBox(width: 16,),
          Image.asset('assets/images/hiapple.png')
        ],
      ),
      const SizedBox(height: 8,),
      GestureDetector(
        onTap: ()=> Navigator.pop(context),
        child: Text.rich(
          TextSpan(
            text: "Don't have an account?",
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400
            ),
            children: [
              TextSpan(
                text: ' Sign Up',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: AppColors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600
                ),
              )
            ]
          )
        ),
      )

    ],
  );

  Widget _loginButton(bool isloading)=> Center(
    child: Container(
      width: double.maxFinite,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isloading? AppColors.borderGrey: AppColors.green,
      ),
      child: const Center(
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    ),
  );

  Widget _field(TextEditingController controller, IconData icon, String hintText, bool isObscured)=> Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      obscureText: isObscured,
      validator: (value) {
        if (value == null || value.length < 8) {
          return 'invalid field';
        } else {
          return null;
        }
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
    ),
  );
}