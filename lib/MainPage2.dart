import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import './ChatPage.dart';
import './ChatsListPage.dart';
import 'BLEDevicePage.dart';
import 'ContactsPage.dart';
import './ContactFormScreen.dart';

//import './LineChart.dart';
Color myGreen = Color(0xff4bb17b);

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin {
  SharedPreferences prefs;
  String userId;
  DeviceIdentifier savedDeviceId;
  BluetoothDevice device;
  StreamSubscription<BluetoothDeviceState> deviceStateStream;

  bool isConnecting = true;
  bool isConnected = false;
  bool isDisconnecting = false;

  int _index;
  ChatsListPage chatsListPage;
  ContactPage contactsPage;
  @override
  void initState() {
    super.initState();

    _index = 0;
    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBlue.instance.isOn) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) async {
      List<BluetoothDevice> connectedDevices =
          await FlutterBlue.instance.connectedDevices;

      SharedPreferences.getInstance().then((prefs) async {
        this.prefs = prefs;
        this.savedDeviceId =
            DeviceIdentifier(this.prefs.getString("savedDevice") ?? "");

        if (savedDeviceId == null || savedDeviceId.id == "") {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
                builder: (context) => FindDevicesScreen(this.userId, prefs)),
          )
              .then((value) {
            setState(() {
              this.savedDeviceId = DeviceIdentifier(value);
              getDeviceFromId();
            });
          });
          print("DeviceId:  ${this.savedDeviceId.id}");
        } else if (connectedDevices.isNotEmpty) {
          BluetoothDevice connectedDevice = connectedDevices
              .firstWhere((d) => d.id.id == this.savedDeviceId.id, orElse: () {
            print("No matching element");
            return null;
          });
          if (connectedDevice != null) {
            setState(() {
              print("chatsListPage refeshed");

              this.device = connectedDevice;
              print("Device1 is ${this.device}");

              // chatsListPage =
              //     ChatsListPage(device: connectedDevice, userId: this.userId);
            });
            // this.device = connectedDevice;
            print("Connected to ${this.device.id}");
            // chatsListPage =
            //     ChatsListPage(device: this.device, userId: this.userId);
            // setState(() {});
          } else {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                  builder: (context) => FindDevicesScreen(this.userId, prefs)),
            )
                .then((value) {
              setState(() {
                this.savedDeviceId = DeviceIdentifier(value);
                getDeviceFromId();
              });
            });
            print("DeviceId:  ${this.savedDeviceId.id}");
          }
        }

        setState(() {
          userId = prefs.getString("userId") ?? "";
        });
      });
    });
    print("Chats List page: ");
    print(chatsListPage);
    setState(() {
      print("Testing");
      // chatsListPage = ChatsListPage(device: this.device, userId: this.userId);
      contactsPage = ContactPage();
    });
  }

  void getDeviceFromId() {
    print("SavedDeviceId: ${this.savedDeviceId.toString()}");
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    StreamSubscription<List<ScanResult>> scanResults =
        FlutterBlue.instance.scanResults.listen((results) async {
      if (this.device == null) {
        FlutterBlue.instance.stopScan();

        print("chatsListPage1 refeshed");

        ScanResult foundResult = results.firstWhere(
            (r) => r.device.id == this.savedDeviceId,
            orElse: () => null);
        if (foundResult != null) {
          setState(() {
            this.device = foundResult.device;
            print("Device2 is ${this.device}");
          });
          // this.device = foundResult.device;
          await this.device.connect();
          print(foundResult.device.id);

        } else {
          print("Didnt find the device");
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    deviceStateStream.cancel();
    // scanResults.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("Device3 is ${this.device}");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          textTheme:
              Theme.of(context).textTheme.apply(bodyColor: Colors.black45),
          iconTheme: IconThemeData(color: Colors.black45),
          title: Text(_index == 0 ? "Dagr Chat" : "Dagr Contacts"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () => _index == 0
                  ? null
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactFormScreen()),
                    ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          backgroundColor: myGreen,
          child: Icon(Icons.camera),
          onPressed: () {},
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 7.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.message, color: Colors.black45),
                onPressed: () {
                  setState(() {
                    _index = 0;
                  });
                },
              ),
              SizedBox(width: 25),
              IconButton(
                icon: Icon(Icons.person_outline, color: Colors.black45),
                onPressed: () {
                  setState(() {
                    _index = 1;
                  });
                },
              ),
            ],
          ),
        ),
        body: _index == 0
            ? ChatsListPage(device: this.device, userId: this.userId)
            : contactsPage
        // ListView.builder(
        //   itemCount: friendsList.length,
        //   itemBuilder: (ctx, i) {
        //     return
        //   },
        // ),
        );
  }
}
