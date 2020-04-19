import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/Message.dart';

class ReceivedMessagesWidget extends StatelessWidget {
  // final int i;
  final Message message;
  const ReceivedMessagesWidget({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: <Widget>[
          // MyCircleAvatar(
          //   imgUrl: messages[i]['contactImgUrl'],
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${message.source}",
                style: Theme.of(context).textTheme.caption,
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .6),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Color(0xfff9f9f9),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  "${utf8.decode(message.payload)}",
                  style: Theme.of(context).textTheme.body1.apply(
                        color: Colors.black87,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(width: 15),
          // Text(
          //   "${messages[i]['time']}",
          //   style: Theme.of(context).textTheme.body2.apply(color: Colors.grey),
          // ),
        ],
      ),
    );
  }
}