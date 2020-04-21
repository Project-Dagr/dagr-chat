import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dagr_chat/services/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:msgpack_dart/msgpack_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import './ChatPage.dart';
import './ChatsListPage.dart';
import 'BLEDevicePage.dart';
import 'ContactsPage.dart';
import './ContactFormScreen.dart';
import 'models/Message.dart';

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
  StreamSubscription<List<BluetoothService>> deviceServiceStream;
  BluetoothCharacteristic readCharacteristic;
  BluetoothCharacteristic writeCharacteristic;

  bool isConnecting = true;
  bool isConnected = false;
  bool isDisconnecting = false;

  List<String> openChats;

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

        if (savedDeviceId.id == "") {
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
            return null;
          });
          if (connectedDevice != null) {
            setState(() {
              this.device = connectedDevice;
              // chatsListPage =
              //     ChatsListPage(device: connectedDevice, userId: this.userId);
            });
            // this.device = connectedDevice;
            print("Connected to ${this.device.id}");

            this.device.connect();
            setupDevice();
            // chatsListPage =
            //     ChatsListPage(device: this.device, userId: this.userId);
            // setState(() {});
          } else {
            getDeviceFromId();
          }
        } else {
          getDeviceFromId();
        }

        setState(() {
          userId = prefs.getString("userId") ?? "";
        });
        DB
            .query(Message.table,
                distinct: true,
                where: "dest = ?",
                whereArgs: [this.userId],
                columns: ["source", "dest"])
            .mapToList((row) => row)
            .listen((results) {
              setState(() {
                openChats = results.map<String>((result) => result['source']).toList();
              });
            });
      });
    });
  }

  void getDeviceFromId() {
    print("SavedDeviceId: ${this.savedDeviceId.toString()}");
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    StreamSubscription<List<ScanResult>> scanResults =
        FlutterBlue.instance.scanResults.listen((results) async {
      if (this.device == null) {
        ScanResult foundResult = results.firstWhere(
            (r) => r.device.id == this.savedDeviceId,
            orElse: () => null);
        if (foundResult != null) {
          setState(() {
            this.device = foundResult.device;
          });
          // this.device = foundResult.device;
          await this.device.connect();
          print(foundResult.device.id);
          FlutterBlue.instance.stopScan();
          setupDevice();
        }
      }
    });
  }

  void setupDevice() {
    deviceStateStream = this.device.state.listen((state) {
      setState(() {
        isConnecting = (state == BluetoothDeviceState.connecting);
        isConnected = (state == BluetoothDeviceState.connected);
        isDisconnecting = (state == BluetoothDeviceState.disconnecting);
      });
      if (!isConnected) {
        this.device.connect();
      }
    });

    Future.doWhile(() async {
      // Wait until connected
      if (isConnected) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      var _ = this.device.discoverServices();
    });

    deviceServiceStream = this.device.services.listen((services) async {
      if (services.isNotEmpty &&
          (readCharacteristic == null || writeCharacteristic == null)) {
        print("In discover services");
        BluetoothService dagrService = services.singleWhere(
            (service) =>
                service.uuid
                    .toString()
                    .compareTo("a40a4466-5444-4fab-b012-16f820b749a8") ==
                0,
            orElse: null);
        readCharacteristic = dagrService.characteristics.singleWhere(
            (characteristic) =>
                characteristic.uuid
                    .toString()
                    .compareTo("d73d98d8-6e1a-46b9-a949-d174d89ee10d") ==
                0,
            orElse: null);
        writeCharacteristic = dagrService.characteristics.singleWhere(
            (characteristic) =>
                characteristic.uuid
                    .toString()
                    .compareTo("c79c596a-2580-48db-b398-27215023882d") ==
                0,
            orElse: null);

        print("ReadCharacteristic: ${readCharacteristic.toString()}");
        print("WriteCharacteristic: ${writeCharacteristic.toString()}");
        await readCharacteristic.setNotifyValue(true);
        await this.device.requestMtu(255);

        // readStream =
        readCharacteristic.value.listen((data) => _onDataReceived(data));
      }
    });
  }

  Future<void> _onDataReceived(List<int> test) async {
    if (test.isNotEmpty) {
      print("In recieve data on Main page");
      print(test);

      Message message =
          Message.fromMap(jsonDecode(deserialize(Uint8List.fromList(test))));
      print(message.source);
      await DB.insert(Message.table, message);
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    deviceServiceStream.cancel();
    // scanResults.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          textTheme:
              Theme.of(context).textTheme.apply(bodyColor: Colors.black45),
          iconTheme: IconThemeData(color: Colors.black45),
          title: Text(_index == 0 ? "Dagr Chat" : "Dagr Contacts"),
          actions: <Widget>[
            FlatButton(onPressed: () {}, child: Text(this.userId ?? "")),
            // IconButton(
            //   icon: Icon(Icons.search),
            //   onPressed: () {},
            // ),
            // IconButton(
            //   icon: Icon(Icons.add_box),
            //   onPressed: () => _index == 0
            //       ? null
            //       : Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => ContactFormScreen()),
            //         ),
            // ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          backgroundColor: myGreen,
          child: Icon(Icons.add),
          onPressed: () {
            _index == 0
                ? null
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactFormScreen()));
          },
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
            ? ChatsListPage(device: this.device, userId: this.userId, openChats: openChats,)
            : ContactPage(device: this.device, userId: this.userId)
        // ListView.builder(
        //   itemCount: friendsList.length,
        //   itemBuilder: (ctx, i) {
        //     return
        //   },
        // ),
        );
  }
}
