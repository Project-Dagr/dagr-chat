import 'dart:convert';

import './model.dart';

class Contact extends Model {
  static String table = 'contacts';

  String firstname;
  String lastname;
  String userId;
  List<int> payload;

  Contact({this.firstname, this.lastname, this.userId});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'firstname': firstname,
      'lastname': lastname,
      'userId': userId
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  String toJSON() => jsonEncode(toMap());

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
        firstname: map['firstname'],
        lastname: map['lastname'],
        userId: map['userId']);
  }
}
