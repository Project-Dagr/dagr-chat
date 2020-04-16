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

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  final String userId;

  ChatPage({this.server, this.userId});

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

  bool isConnecting = true;
  // bool get isConnected => widget.server.state ==
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

    stateStream = widget.server.state.listen((state) => {
          setState(() {
            isConnecting = (state == BluetoothDeviceState.connecting);
            isConnected = (state == BluetoothDeviceState.connected);
            isDisconnecting = (state == BluetoothDeviceState.disconnecting);
          })
        });

    widget.server.connect();

    serviceStream = widget.server.services.listen((services) async {
      // print(services);
      List<BluetoothCharacteristic> characteristics;
      print("In discover services");
      BluetoothService dagrService = services.singleWhere((service) =>
          service.uuid
              .toString()
              .compareTo("a40a4466-5444-4fab-b012-16f820b749a8") ==
          0);
      readCharacteristic = dagrService.characteristics.singleWhere(
          (characteristic) =>
              characteristic.uuid
                  .toString()
                  .compareTo("d73d98d8-6e1a-46b9-a949-d174d89ee10d") ==
              0);
      writeCharacteristic = dagrService.characteristics.singleWhere(
          (characteristic) =>
              characteristic.uuid
                  .toString()
                  .compareTo("c79c596a-2580-48db-b398-27215023882d") ==
              0);

      print("ReadCharacteristic: ${readCharacteristic.toString()}");
      print("WriteCharacteristic: ${writeCharacteristic.toString()}");
      await readCharacteristic.setNotifyValue(true);
      await widget.server.requestMtu(255);

      readStream =
          readCharacteristic.value.listen((data) => _onDataReceived(data));

      // await readCharacteristic.read();
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
      widget.server.disconnect();
      stateStream.cancel();
      serviceStream.cancel();
    }

    super.dispose();
  }

  Future<void> refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(Message.table);
    messages = _results.map((item) => Message.fromMap(item)).toList();
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(utf8.decode(message.payload)),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color: message.source == clientID
                    ? Colors.blueAccent
                    : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: message.source == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return Scaffold(
        appBar: AppBar(
            title: (isConnecting
                ? Text('Connecting chat to ' + widget.server.name + '...')
                : isConnected
                    ? Text('Live chat with ' + widget.server.name)
                    : Text('Chat log with ' + widget.server.name))),
        body: SafeArea(
            child: Column(children: <Widget>[
          Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
                  children: list)),
          Row(children: <Widget>[
            Flexible(
              child: Container(
                  margin: const EdgeInsets.only(left: 16.0),
                  child: TextField(
                    style: const TextStyle(fontSize: 15.0),
                    controller: textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: (isConnecting
                          ? 'Wait until connected...'
                          : isConnected
                              ? 'Type your message...'
                              : 'Chat got disconnected'),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    enabled: isConnected,
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(textEditingController.text)),
            ),
          ])
        ])));
  }

  Future<void> _onDataReceived(List<int> test) async {
    // if (!readingValue) {
    // setState(() {
    //   readingValue = true;
    // });
    print("In recieve data");
    print(test);

    Message message =
        Message.fromMap(jsonDecode(deserialize(test as Uint8List)));
    print(message.source);
    await DB.insert(Message.table, message);
    setState(() {
      messages = List<Message>();
    });
    await refresh();
    // setState(() {
    //   readingValue = false;
    // });
    Future.delayed(Duration(milliseconds: 333)).then((_) {
      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 333),
          curve: Curves.easeOut);
    });
    return;
    // }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        // Message message = Message(clientID, text);
        // ChatMessage message = ChatMessage();
        // message.from = this.clientID;
        // message.to = "77b35958-b093-42f2-818c-36ba8a210294";
        // message.from = 0;
        // message.to = 1;
        // message.message = utf8.encode(text);
        Message message = Message(
            source: widget.userId, dest: "-1", payload: utf8.encode(text));

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
