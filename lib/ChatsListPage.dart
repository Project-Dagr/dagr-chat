import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'ChatPage.dart';

class ChatsListPage extends StatelessWidget {
  final BluetoothDevice device;
  final String userId;
  final List<String> openChats;

  ChatsListPage({this.device, this.userId, this.openChats}) {
    print(this.device);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        ListTile(
          // isThreeLine: true,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    server: this.device, userId: this.userId, chat: "-1")),
          ), // handle your onTap here,
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    offset: Offset(0, 5),
                    blurRadius: 25)
              ],
            ),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CircleAvatar(
                    backgroundColor: Colors.brown.shade800,
                    child: Icon(Icons.account_circle),
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            "General",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Divider(),
        Expanded(child: ListView.builder(
          itemCount: this.openChats?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              // isThreeLine: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                        server: this.device,
                        userId: this.userId,
                        chat: this.openChats[index])),
              ), // handle your onTap here,
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        offset: Offset(0, 5),
                        blurRadius: 25)
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CircleAvatar(
                        backgroundColor: Colors.brown.shade800,
                        child: Icon(Icons.account_circle),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                this.openChats[index],
                style: Theme.of(context).textTheme.title,
              ),
            );
          },
        ))
      ],
    );
  }
}
