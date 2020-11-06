import 'dart:ui';
import 'package:flutter/material.dart';
class MyButton extends StatelessWidget {
  final String title;
  final Function fn;
  const MyButton(this.title,{Key key, this.fn}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(this.title),
      textColor: Colors.black87,
      color: Colors.white,
      highlightColor: Colors.black12,
      onPressed: (){
        if(this.fn !=null) {
          this.fn();
        }
      },
    );
  }

}