import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_common/components/test.dart';

class PlatformChannelTest extends StatefulWidget {
  @override
  _PlatformChannelPageState createState() => _PlatformChannelPageState();
}

class _PlatformChannelPageState extends State<PlatformChannelTest> {
  static const platform = const MethodChannel('native');

  String _batteryLevel = '未知';
  String _openResult = "";

  // 调用平台方法
  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = '电池电量还有 $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  // 打开原生页面
  Future<Null> _openTest() async {
    try {
      setState(() {
        _openResult = "success";
      });
      await platform.invokeMethod('testpage');
    } on PlatformException catch (e) {
      print("Failed to get battery level: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TestItem(
              text: "获取本机电量",
              result: _batteryLevel,
              onPressed: _getBatteryLevel),
          TestItem(text: "打开原生页面", result: _openResult, onPressed: _openTest),
        ],
      ),
    );
  }
}


