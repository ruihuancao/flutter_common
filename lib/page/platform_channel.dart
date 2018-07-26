import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class PlatformChannelPage extends StatefulWidget {
  @override
  _PlatformChannelPageState createState() => _PlatformChannelPageState();
}

class _PlatformChannelPageState extends State<PlatformChannelPage> {

  static const platform = const MethodChannel('native');

  String _batteryLevel = 'Unknown battery level.';

  // 调用平台方法
  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  // 打开原生页面
  Future<Null> _openTest() async {
    try{
      await platform.invokeMethod('testpage');
    } on PlatformException catch(e){
      print("Failed to get battery level: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("平台代码调用"),
      ),
      body: new Center(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new RaisedButton(
                child: new Text('Get Battery Level'),
                onPressed: _getBatteryLevel,
              ),
              new RaisedButton(
                child: new Text('Open Test Page'),
                onPressed: _openTest,
              ),
              new Text(_batteryLevel),
            ],
          ),
        ),
      ),
    );
  }
}
