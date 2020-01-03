import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final IconData icon;
  final String text;
  Function onPressed;

Info({
  @required this.icon,
  @required this.text,
  this.onPressed, List<Widget> children, 
}
);
@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        //color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.deepOrange,
          ), 
          title: Text(
            text,
            style: TextStyle(
              fontFamily: 'Source Sans Pro',
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}