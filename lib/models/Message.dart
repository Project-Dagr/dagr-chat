import './model.dart';
import 'dart:convert';


int id_counter = 0;

class Message extends Model {
  static String table = 'messages';

  String source;
  String dest;
  List<int> payload;

  Message({this.source, this.dest, this.payload});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'source': source,
      'dest': dest,
      'payload': payload
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  String toJSON() => jsonEncode(toMap());

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
        source: map['source'],
        dest: map['dest'],
        payload: map['payload'].cast<int>());
  }
}
