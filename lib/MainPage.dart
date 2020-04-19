// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import './ChatPage.dart';
// import 'BLEDevicePage.dart';

// //import './LineChart.dart';
// Color myGreen = Color(0xff4bb17b);

// class MainPage extends StatefulWidget {
//   @override
//   _MainPage createState() => new _MainPage();
// }

// class _MainPage extends State<MainPage> {
//   SharedPreferences prefs;
//   String userId;
//   DeviceIdentifier savedDeviceId;
//   BluetoothDevice device;
//   StreamSubscription<BluetoothDeviceState> deviceStateStream;

//   bool isConnecting = true;
//   bool isConnected = false;
//   bool isDisconnecting = false;

//   @override
//   void initState() {
//     super.initState();

//     Future.doWhile(() async {
//       // Wait if adapter not enabled
//       if (await FlutterBlue.instance.isOn) {
//         return false;
//       }
//       await Future.delayed(Duration(milliseconds: 0xDD));
//       return true;
//     }).then((_) async {
//       List<BluetoothDevice> connectedDevices =
//           await FlutterBlue.instance.connectedDevices;

//       SharedPreferences.getInstance().then((prefs) {
//         this.prefs = prefs;
//         this.savedDeviceId =
//             DeviceIdentifier(this.prefs.getString("savedDevice") ?? "");

//         if (savedDeviceId == null || savedDeviceId.id == "") {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//                 builder: (context) => FindDevicesScreen(this.userId)),
//           );
//         } else if (connectedDevices.isNotEmpty) {
//           BluetoothDevice connectedDevice = connectedDevices
//               .firstWhere((d) => d.id.id == this.savedDeviceId.id, orElse: () {
//             print("No matching element");
//             return null;
//           });
//           if (connectedDevice != null) {
//             this.device = connectedDevice;
//             print("Connected to ${this.device.id}");
//           } else {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                   builder: (context) => FindDevicesScreen(this.userId)),
//             );
//           }
//         } else {
//           FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
//           StreamSubscription<List<ScanResult>> scanResults =
//               FlutterBlue.instance.scanResults.listen((results) async {
//             if (this.device == null) {
//               ScanResult foundResult = results.firstWhere(
//                   (r) => r.device.id == this.savedDeviceId,
//                   orElse: () => null);
//               if (foundResult != null) {
//                 this.device = foundResult.device;
//                 await this.device.connect();
//                 print(foundResult.device.id);
//               }
//             }
//           });
//           FlutterBlue.instance.stopScan();
//         }
//         setState(() {
//           userId = prefs.getString("userId") ?? "";
//         });
//       });
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[900],
//       appBar: AppBar(
//         title: const Text('Dagr Chat'),
//         backgroundColor: Colors.black,
//       ),
//       // body: Container(
//       //   child: ListView(
//       //     children: <Widget>[
//       //       Divider(),
//       //       InkWell(
//       //         onTap: () => Navigator.of(context).push(
//       //           MaterialPageRoute(
//       //               builder: (context) => ChatPage(
//       //                   server: this.device, userId: this.userId, chat: "-1")),
//       //         ), // handle your onTap here
//       //         child: Container(
//       //           height: 70,
//       //           color: Colors.amber[500],
//       //           child: const Center(child: Text('General Chat')),
//       //         ),
//       //       ),

//       //       RaisedButton(
//       //         color: Colors.orange[400],
//       //         child: const Text('Removed Saved Device'),
//       //         onPressed: () {
//       //           print("removing SavedDevice");
//       //           this.prefs.setString("savedDevice", null);
//       //         },
//       //       ),
//       //       RaisedButton(
//       //         color: Colors.orange[400],
//       //         child: const Text('Disconnect from device'),
//       //         onPressed: () async {
//       //           print("Disconnecting Device");
//       //           await this.device.disconnect();
//       //         },
//       //       ),
//       //       // RaisedButton(
//       //       //   color: Colors.orange[400],
//       //       //   child: const Text('Removed Saved Device'),
//       //       //   onPressed: () {
//       //       //    Navigator.of(context).
//       //       //   },
//       //       // )
//       //     ],
//       //   ),
//       // ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         elevation: 5,
//         backgroundColor: myGreen,
//         child: Icon(Icons.camera),
//         onPressed: () {},
//       ),
//       bottomNavigationBar: BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 7.0,
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: Icon(Icons.message, color: Colors.black45),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: Icon(Icons.view_list, color: Colors.black45),
//               onPressed: () {},
//             ),
//             SizedBox(width: 25),
//             IconButton(
//               icon: Icon(Icons.call, color: Colors.black45),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: Icon(Icons.person_outline, color: Colors.black45),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//       leading: Container(
//         width: 50,
//         height: 50,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: Colors.white,
//             width: 3,
//           ),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey.withOpacity(.3),
//                 offset: Offset(0, 5),
//                 blurRadius: 25)
//           ],
//         ),
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: CircleAvatar(
//                 backgroundColor: Colors.brown.shade800, 
//                 child: Icon(Icons.account_circle),
//               ),
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }
