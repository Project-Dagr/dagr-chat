import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './BLEDevicePage.dart';
import 'package:uuid/uuid.dart';
import 'package:hashids2/hashids2.dart';

import './MainPage.dart';

void main() => runApp(new DagrMain());

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
          userId = hashids.encode(Random().nextInt(100));
        });
        prefs.setString("userId", this.userId);
      }
      print(this.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: FindDevicesScreen(this.userId));
  }
}
