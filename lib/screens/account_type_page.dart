import 'package:flutter/material.dart';
import 'package:hihealth/screens/patient/signin_or_signup_page.dart';

import 'doctor/doctor_signin_or_signup_page.dart';

class AccountTypePage extends StatefulWidget {
  const AccountTypePage({super.key});

  @override
  State<AccountTypePage> createState() => _AccountTypePageState();
}

class _AccountTypePageState extends State<AccountTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
              width: 190,
              child: Text(
                'Please Select Your Account Type',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: ()=> Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context)=> const SigninOrSignUpPage()
                    )
                  ),
                  child: _card('assets/images/person_image.png', const Color.fromRGBO(229, 12, 248, 1), 'User')),
                GestureDetector(
                  onTap: ()=> Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context)=> const DoctorSigninOrSignUpPage()
                    )
                  ),
                  child: _card('assets/images/link_image.png', const Color.fromRGBO(45, 86, 231, 1), 'Medical Practitioner'))
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget _card(String imageUrl, Color color, String label)=> Padding(
    padding: const EdgeInsets.all(16.0),
    child: GestureDetector(
      child: SizedBox(
        width: 143,
        height: 172,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Container(
                height: 143,
                width: 148,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: color),
                ),
                child: Center(
                  child: Image.asset(
                    imageUrl
                  ),
                ),
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
            )
          ],
        ),
      ),
    ),
  );
}