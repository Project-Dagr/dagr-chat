import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class formScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<formScreen>{
  String _firstName;
  String _lastName;
  String _userID;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildFirstName(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'First Name'),
      validator: (String value){
        if(value.isEmpty){
          return 'Name Required';
        }
      },
      onSaved: (String value){
        _firstName = value;
      },
    );
  }
   Widget _buildLastName(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Last Name'),
      validator: (String value){
        if(value.isEmpty){
          return 'Name Required';
        }
      },
      onSaved: (String value){
        _lastName = value;
      },
    );
  }
   Widget _buildID(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'User ID'),
      validator: (String value){
        if(value.isEmpty){
          return 'ID Required';
        }
      },
      onSaved: (String value){
        _firstName = value;
      },
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
     appBar: AppBar(title: Text ('New Contact'),),
     body: Container(
       margin: EdgeInsets.all(24),
       child: Form(child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[

            _buildFirstName(),
            _buildLastName(),
            _buildID(),
            SizedBox(height: 100,),
            RaisedButton(
             child: Text('Submit'),
             onPressed: () =>{},
            ),
          ],
        ),),
      )
    );
  }
}