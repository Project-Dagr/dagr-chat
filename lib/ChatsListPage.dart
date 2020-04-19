import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'ChatPage.dart';

class ChatsListPage extends StatefulWidget {
  final BluetoothDevice device;
  final String userId;

  ChatsListPage({this.device, this.userId}) {
    print(this.device);
  }


  @override
  _ChatsListPage createState() => new _ChatsListPage();
}

class _ChatsListPage extends State<ChatsListPage> {


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
                    server: this.widget.device, userId: this.widget.userId, chat: "-1")),
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
          // subtitle: Text(
          //   "${friendsList[i]['lastMsg']}",
          //   style: !friendsList[i]['seen']
          //       ? Theme.of(context)
          //           .textTheme
          //           .subtitle
          //           .apply(color: Colors.black87)
          //       : Theme.of(context)
          //           .textTheme
          //           .subtitle
          //           .apply(color: Colors.black54),
          // ),
          // trailing: Container(
          //   width: 60,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: <Widget>[
          //       Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: <Widget>[
          //           friendsList[i]['seen']
          //               ? Icon(
          //                   Icons.check,
          //                   size: 15,
          //                 )
          //               : Container(height: 15, width: 15),
          //           Text("${friendsList[i]['lastMsgTime']}")
          //         ],
          //       ),
          //       SizedBox(
          //         height: 5.0,
          //       ),
          //       friendsList[i]['hasUnSeenMsgs']
          //           ? Container(
          //               alignment: Alignment.center,
          //               height: 25,
          //               width: 25,
          //               decoration: BoxDecoration(
          //                 color: myGreen,
          //                 shape: BoxShape.circle,
          //               ),
          //               child: Text(
          //                 "${friendsList[i]['unseenCount']}",
          //                 style: TextStyle(color: Colors.white),
          //               ),
          //             )
          //           : Container(
          //               height: 25,
          //               width: 25,
          //             ),
          //     ],
          //   ),
          // ),
        ),
        Divider()
      ],
    );
  }
}
