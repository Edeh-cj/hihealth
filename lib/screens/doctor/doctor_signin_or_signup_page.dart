import 'package:flutter/material.dart';
import 'package:hihealth/screens/doctor/doctor_login_page.dart';
import 'package:hihealth/screens/doctor/doctor_signup_page.dart';

import '../../utilities/app_colors.dart';

class DoctorSigninOrSignUpPage extends StatelessWidget {
  const DoctorSigninOrSignUpPage({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48,),
                Image.asset('assets/images/hilogo2.png'),
                const Spacer(),
                GestureDetector(
                  onTap: ()=> Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context)=> const DoctorLoginPage()
                    )
                  ),
                  child: _continueButton()),
                const SizedBox(height: 16,),
                GestureDetector(
                  onTap: ()=> Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context)=> const DoctorSignupPage()
                    )
                  ),
                  child: _signupButton()),
                const SizedBox(height: 16,),
                _federationSignup()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _continueButton()=> Center(
    child: Container(
      width: double.maxFinite,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.green,
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
      

    ],
  );

  Widget _signupButton()=> Center(
    child: Container(
      width: double.maxFinite,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderGrey)
      ),
      child: const Center(child: Text(
        'Sign Up',
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w600
        ),
      )),
    ),
  );
}