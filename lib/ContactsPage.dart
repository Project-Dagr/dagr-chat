import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dagr_chat/ChatPage.dart';
import 'package:flutter_blue/flutter_blue.dart';

import './services/db.dart';

import './models/Contact.dart';
import 'package:flutter/material.dart';
import './ContactFormScreen.dart';

class ContactPage extends StatefulWidget {
  final BluetoothDevice device;
  final String userId;
  ContactPage({this.device, this.userId});
  @override
  _ContactPageEmpty createState() => new _ContactPageEmpty();
}

class _ContactPageEmpty extends State<ContactPage> {
  List<Contact> _contacts;

  @override
  initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    List<Map<String, dynamic>> contacts = await DB.query(Contact.table);
    _contacts = contacts.map((item) => Contact.fromMap(item)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: AppBar(
      //   backgroundColor: Colors.black12,
      //   title: (Text(
      //     'Contacts',
      //   )),
      // ),
      body: Center(
        child: _contacts != null && _contacts.isNotEmpty
            ? ListView.builder(
                itemCount: _contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = _contacts?.elementAt(index);
                  return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 18),
                      leading: CircleAvatar(
                        child: Text(
                            "${contact.firstname[0].toUpperCase()}${contact.lastname[0].toUpperCase()}",
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: Theme.of(context).accentColor,
                      ),
                      title: Text(
                          "${contact.firstname} ${contact.lastname}: ${contact.userId}",
                          style: TextStyle(color: Colors.white)),
                      //This can be further expanded to showing contacts detail
                      // onPressed().
                      onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    server: widget.device,
                                    userId: this.widget.userId,
                                    chat: contact.userId)),
                          ));
                })
            : Text(
                'You have no friends yet, click to add some!',
                style: TextStyle(color: Colors.white),
              ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add, color: Colors.black,),
      //   backgroundColor: Colors.orange[400],
      //   onPressed: (){
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => formScreen()),
      //       );

      //   },

      // ),
    );
  }
}
