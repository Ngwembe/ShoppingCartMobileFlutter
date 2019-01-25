import 'package:flutter/material.dart';

class SentMessage extends StatelessWidget{
  final String message;
  SentMessage({this.message});
  @override
  Widget build(BuildContext context) {
    
    return  Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Material(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
            child:Padding(
              padding: EdgeInsets.all(20.0),
              child:Container(
  width: 230.0,
  child: Text(
    message
  ),
)// Text(message),
            ) 
          )
          
          ],
      
    );
  }

}