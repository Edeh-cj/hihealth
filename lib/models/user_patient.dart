import 'package:hihealth/models/user.dart';

class UserPatient implements User{
  @override
  final String name, imageUrl;
  final String language;

  UserPatient({required this.imageUrl, required this.name, required this.language});
  
  @override
  set name(String _name) {
    // TODO: implement name
  }
  
  @override
  set imageUrl(String _imageUrl) {
    // TODO: implement imageUrl
  }
}