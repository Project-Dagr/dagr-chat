import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/Message.dart';


Color myGreen = Color(0xff4bb17b);


class SentMessageWidget extends StatelessWidget {
    final Message message;

  const SentMessageWidget({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Text(
          //   "${messages[i]['time']}",
          //   style: Theme.of(context).textTheme.body2.apply(color: Colors.grey),
          // ),
          SizedBox(width: 15),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .6),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: myGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            child: Text(
              "${utf8.decode(message.payload)}",
              style: Theme.of(context).textTheme.body2.apply(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}