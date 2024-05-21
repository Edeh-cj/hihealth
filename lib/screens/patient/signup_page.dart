import 'package:flutter/material.dart';
import 'package:hihealth/screens/patient/account_setup_page.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_notifier.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/app_functions.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: GestureDetector(
          onTap: (){Navigator.pop(context);},
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48,),
                const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.black ,
                    fontSize: 32,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 32,),
                _field(_nameController, Icons.person, 'Enter your name', false),
                _field(_emailController, Icons.email, 'Enter your Email', false),
                _field(_passwordController, Icons.lock_rounded, 'Password', true),
                _field(_confirmPasswordController, Icons.lock_rounded, 'Confirm Your Password', true),
                GestureDetector(
                  onTap: () async{
                    if (_formKey.currentState!.validate()) {
                      toggleloading(true);
                      await context.read<AuthNotifier>().registerUserPatient(
                        name: _nameController.text, 
                        email: _emailController.text, 
                        password: _passwordController.text
                      ).then((value) {
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(
                            builder: (context)=> const AccountSetupPage()
                          )
                        );
                      }).catchError((error){
                        AppFunctions.showSnackbar(context, error);
                        toggleloading(false);
                      });
                    } 
                  },
                  child: _continueButton(isloading)),
                const SizedBox(height: 16,),
                _federationSignup(),
                const SizedBox(height: 32,)
          
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _continueButton(bool isloading)=> Center(
    child: Container(
      width: double.maxFinite,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isloading? AppColors.borderGrey: AppColors.green,
      ),
      child: const Center(
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    ),
  );

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
      Text.rich(
        TextSpan(
          text: 'Already have an account?',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400
          ),
          children: [
            TextSpan(
              text: ' Sign in',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: AppColors.green,
                fontSize: 12,
                fontWeight: FontWeight.w600
              ),
            )
          ]
        )
      )

    ],
  );

  Widget _field(TextEditingController controller, IconData icon, String hintText, isObscured)=> Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      obscureText: isObscured,
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