import 'dart:async';
import 'dart:math';

import 'package:dagr_chat/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './BLEDevicePage.dart';
import 'package:hashids2/hashids2.dart';
import './services/db.dart';
import './MainPage2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(new DagrMain());
}

class DagrMain extends StatefulWidget {
  @override
  _DagrState createState() => new _DagrState();
}

class _DagrState extends State<DagrMain> {
  SharedPreferences prefs;
  String userId;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      this.prefs = prefs;
      final hashids = HashIds(
        salt: 'Project Dagr!!!!',
        minHashLength: 6,
        alphabet:
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
      );

      setState(() {
        userId = prefs.getString("userId") ?? "";
      });
      if (this.userId == "") {
        setState(() {
          userId = hashids.encode(Random().nextInt(100)).toUpperCase();
        });
        prefs.setString("userId", this.userId);
      }
      print(this.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: MainPage());
  }
}
