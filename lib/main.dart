import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './BLEDevicePage.dart';
import 'package:uuid/uuid.dart';

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
      var uuid = Uuid();

      setState((){
        userId = prefs.getString("userId") ?? "";
      });
      if (this.userId == "") {
        setState(() {
          userId = uuid.v4();
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
