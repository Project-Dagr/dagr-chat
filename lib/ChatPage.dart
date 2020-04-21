import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:msgpack_dart/msgpack_dart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import './services/db.dart';
import './models/Message.dart';
import './widgets/RecievedMessageWidget.dart';
import './widgets/SentMessageWidget.dart';

Color myGreen = Color(0xff4bb17b);

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  final String userId;
  final String chat;

  ChatPage({this.server, this.userId, this.chat});

  @override
  _ChatPage createState() => new _ChatPage(this.userId);
}

class _ChatPage extends State<ChatPage> {
  final clientID;
  static final maxMessageLength = 4096 - 3;

  _ChatPage(this.clientID);
  // BluetoothConnection connection;

  List<Message> messages = List<Message>();
  String messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  BluetoothCharacteristic readCharacteristic;
  BluetoothCharacteristic writeCharacteristic;

  bool isConnecting = false;
  bool isConnected = false;
  bool isDisconnecting = false;

  StreamSubscription<BluetoothDeviceState> stateStream;
  StreamSubscription<List<BluetoothService>> serviceStream;
  StreamSubscription<List<int>> readStream;

  bool readingValue = false;

  @override
  void initState() {
    refresh();
    super.initState();
    stateStream = widget.server.state.listen((state) {
      setState(() {
        isConnecting = (state == BluetoothDeviceState.connecting);
        isConnected = (state == BluetoothDeviceState.connected);
        isDisconnecting = (state == BluetoothDeviceState.disconnecting);
      });
      if (!isConnected) {
        widget.server.connect();
      }
    });

    serviceStream = widget.server.services.listen((services) async {
      // print(services);
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
        await widget.server.requestMtu(255);

        readStream =
            readCharacteristic.value.listen((data) => _onDataReceived(data));

        // await readCharacteristic.read();
      }
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBlue.instance.isOn) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {});

    Future.doWhile(() async {
      // Wait until connected
      if (isConnected) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      var _ = widget.server.discoverServices();
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect

    if (isConnected) {
      // widget.server.disconnect();
      stateStream.cancel();
      serviceStream.cancel();
      readStream.cancel();
    }

    super.dispose();
  }

  Future<void> refresh() async {
    List<Map<String, dynamic>> _results;
    if (this.widget.chat == "-1") {
      _results =
          await DB.query(Message.table, where: "dest = ?", whereArgs: ["-1"]);
    } else {
      _results = await DB.query(Message.table,
          where: "source = ?", whereArgs: [this.widget.chat]);
    }
    messages = _results.map((item) => Message.fromMap(item)).toList();
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // MyCircleAvatar(
            //   imgUrl: friendsList[0]['imgUrl'],
            // ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.chat == "-1" ? "General" : widget.chat,
                  style: Theme.of(context).textTheme.subhead,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  isConnected ? "Connected": "Disconnected" ,
                  style: Theme.of(context).textTheme.subtitle.apply(
                        color: isConnected ? myGreen : Colors.grey,
                      ),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.phone),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: Icon(Icons.videocam),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: Icon(Icons.more_vert),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: messages.length,
                    controller: listScrollController,
                    itemBuilder: (ctx, i) {
                      if (messages[i].source != this.widget.userId) {
                        return ReceivedMessagesWidget(message: messages[i]);
                      } else {
                        return SentMessageWidget(message: messages[i]);
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  height: 61,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                  color: Colors.grey)
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.face), onPressed: () {}),
                              Expanded(
                                child: TextField(
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                      hintText: (isConnecting
                                          ? 'Wait until connected...'
                                          : isConnected
                                              ? 'Type your message...'
                                              : 'Chat got disconnected'),
                                      enabled: isConnected,
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: myGreen, shape: BoxShape.circle),
                        child: InkWell(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onTap: () => _sendMessage(textEditingController.text),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onDataReceived(List<int> test) async {
    if (test.isNotEmpty) {
      print("In recieve data");
      print(test);

      Message message =
          Message.fromMap(jsonDecode(deserialize(Uint8List.fromList(test))));
      print(message.source);
      await DB.insert(Message.table, message);
      setState(() {
        messages = List<Message>();
      });
      await refresh();
      Future.delayed(Duration(milliseconds: 333)).then((_) {
        listScrollController.animateTo(
            listScrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 333),
            curve: Curves.easeOut);
      });
      return;
      // }
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        Message message = Message(
            source: widget.userId, dest: widget.chat, payload: utf8.encode(text));

        var encodedMessage = serialize(message.toJSON());
        print(message.toMap());
        print(encodedMessage);

        await writeCharacteristic.write(encodedMessage);

        await DB.insert(Message.table, message);
        setState(() {
          messages = List<Message>();
        });
        refresh();

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        print(e);
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
