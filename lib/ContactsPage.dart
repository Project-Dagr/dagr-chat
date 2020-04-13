import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './ContactsForm.dart';
import './formScreen.dart';

class ContactPage extends StatefulWidget{
  
  @override
  _ContactPageEmpty createState() => new _ContactPageEmpty();


}

class _Contact {
  String firstName;
  String lastName;
  String unitID;
}

class _ContactPageEmpty extends State<ContactPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: (
          Text('Contacts',)
        ),
      ),
      body: Center(
       child: const Text('You have no friends yet, click to add some!', style: TextStyle(color: Colors.white),),
       
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.black,),
        backgroundColor: Colors.orange[400],
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => formScreen()),
            );
        
        },

      ),
      

    );
  }

}