import 'package:hihealth/models/user.dart';

class UserDoctor implements User{
  @override
  // @override
  // @override
  @override
  final String name, imageUrl;
  final bool isonline;
  final String uid;
  final String about, specialization, company;
  final List languages;

  UserDoctor({required this.isonline, required this.uid, required this.about, required this.languages, required this.name, required this.specialization, required this.company,required this.imageUrl});
  UserDoctor.dummy():
    name= 'Dr. Ijeoma Ibe',
    specialization= 'Cardio Specialist',
    company= '-',
    isonline = true,
    uid = 'bbbbb',
    languages = ['Hausa', 'English'],
    about = dummyString,
    imageUrl = '';
    
    UserDoctor.placeholder():
    name= '-',
    specialization= '-',
    company= '-',
    isonline = true,
    uid = '-',
    languages = ['Hausa', 'English'],
    about = '-',
    imageUrl = 'assets/images/image_holder.png';

      @override
      set imageUrl(String imageUrl_) {
    // TODO: implement imageUrl
      }
    
      @override
      set name(String name_) {
    // TODO: implement name
      }
}

String dummyString = "Dr. Anderson's expertise lies in diagnosing and treating a wide range of medical conditions affecting adults. Her deep knowledge of the human body's systems allows her to provide comprehensive care to her patients. She has a particular interest in complex cases and enjoys the challenge of finding solutions to difficult medical puzzles.";