import 'package:flutter/material.dart';

class TestItem extends StatelessWidget {
  final Function onPressed;
  final String text;
  final String result;

  TestItem({this.text, this.result, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              RaisedButton(onPressed: onPressed, child: Container(child: new Text(text), width: 100.0,)),
              Text(result)
            ],
          ),
          Divider(height: 2.0,)
        ],
      ),
    );
  }
}