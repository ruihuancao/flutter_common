import 'package:flutter/material.dart';
import 'package:flutter_common/setting/setting.dart';

//
class SettingsPage extends StatelessWidget {

  final Settings settings;
  final Function settingsChange;

  SettingsPage({this.settings, this.settingsChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("设置"),
      ),
      body: new Container(
        child: new Center(
          child: new Text("设置页面"),
        ),
      ),
    );
  }
}
