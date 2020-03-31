import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './BLEDevicePage.dart';
import 'package:uuid/uuid.dart';

import './MainPage.dart';

void main() => runApp(new DagrMain());

class DagrMain extends StatelessWidget {
  SharedPreferences prefs;
  String userId;

  DagrMain() {
    SharedPreferences.getInstance().then((prefs) {
      this.prefs = prefs;
      var uuid = Uuid();

      this.userId = prefs.getString("userId") ?? "";
      if (this.userId == "") {
        this.userId = uuid.v4();
        prefs.setString("userId", this.userId);
      }
      print(this.userId);

    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FindDevicesScreen(this.userId));
  }
}
