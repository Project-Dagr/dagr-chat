import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './ChatPage.dart';
import 'BLEDevicePage.dart';

//import './LineChart.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  SharedPreferences prefs;
  String userId;
  DeviceIdentifier savedDeviceId;
  BluetoothDevice device;
  StreamSubscription<BluetoothDeviceState> deviceStateStream;

  bool isConnecting = true;
  bool isConnected = false;
  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      this.prefs = prefs;
      this.savedDeviceId =
          DeviceIdentifier(this.prefs.getString("savedDevice"));

      if (savedDeviceId == null) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => FindDevicesScreen(this.userId)),
        );
      } else {
        FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
        StreamSubscription<List<ScanResult>> scanResults =
            FlutterBlue.instance.scanResults.listen((results) {

              for (var result in results) {
                print(result.device.id);
              }
              // print(devices);
          // this.device = devices
          //     .singleWhere((d) => d.device.id == this.savedDeviceId)
          //     .device;
          // deviceStateStream = this.device.state.listen((state) {
          //   // this.prefs.setBool("isConnecting", (state == BluetoothDeviceState.connecting));
          //   // this.prefs.setBool("isConnected", (state == BluetoothDeviceState.connected));
          //   // this.prefs.setBool("isDisconnecting", (state == BluetoothDeviceState.disconnecting));

          //   setState(() {
          //     isConnecting = (state == BluetoothDeviceState.connecting);
          //     isConnected = (state == BluetoothDeviceState.connected);
          //     isDisconnecting = (state == BluetoothDeviceState.disconnecting);
          //   });

          // });
        });
        // Future.doWhile(() {
        //     if(this.device != null)
        // }));

      }
      setState(() {
        userId = prefs.getString("userId") ?? "";
      });
    });

    // Get current state
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Dagr Chat'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(),
            ListTile(
                title: const Text('General',
                    style: TextStyle(color: Colors.white))),
            RaisedButton(
              color: Colors.orange[400],
              child: const Text('Removed Saved Device'),
              onPressed: () {
                this.prefs.setString("savedDevice", null);
              },
            ),
            // RaisedButton(
            //   color: Colors.orange[400],
            //   child: const Text('Removed Saved Device'),
            //   onPressed: () {
            //    Navigator.of(context).
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
