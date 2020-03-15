import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  static final maxMessageLength = 4096 - 3;
  // BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

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

  @override
  void initState() {
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
      readCharacteristic.value
          .listen((data) => _onDataReceived(Uint8List.fromList(data)));
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

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
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

  void _onDataReceived(Uint8List data) {
    print("In recieve data");
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    print(dataString);
    if (dataString != "") {
      setState(() {
        messages.add(_Message(1, dataString));
      });
    }

    // MessagePacket messagePacket;
    // int index = buffer.indexOf(13);
    // if (~index != 0) {
    //   print("test");
    //   // \r\n
    //   // messagePacket = MessagePacket.fromBuffer(dataString);
    //   setState(() {
    //     messages.add(_Message(
    //         1,
    //         backspacesCounter > 0
    //             ? _messageBuffer.substring(
    //                 0, _messageBuffer.length - backspacesCounter)
    //             : _messageBuffer + dataString.substring(0, index)));
    //     _messageBuffer = dataString.substring(index);
    //   });
    // } else {
    //   _messageBuffer = (backspacesCounter > 0
    //       ? _messageBuffer.substring(
    //           0, _messageBuffer.length - backspacesCounter)
    //       : _messageBuffer + dataString);
    // }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        _Message message = _Message(clientID, text);

        await writeCharacteristic.write(utf8.encode(text));

        setState(() {
          messages.add(_Message(clientID, text));
        });

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
