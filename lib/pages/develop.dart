import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';


import 'package:flutter_common/components/platform_channel_test.dart';
import 'package:flutter_common/components/banner_test.dart';
import 'package:flutter_common/components/settings_test.dart';
import 'package:flutter_common/setting/setting.dart';
/// 开发测试页面
class DevelopPage extends StatelessWidget {

  final Color color;
  final Settings settings;
  final Function settingUpdate;

  DevelopPage({this.color, this.settings, this.settingUpdate});

  @override
  Widget build(BuildContext context) {
    // 设置状态栏
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("测试代码"),
        centerTitle: true,
      ),
      body: Container(
        color: color,
        child: ListView(
          children: <Widget>[
            BannerTest(),
            PlatformChannelTest(),
            SettingsTest(settings, settingUpdate),
          ],
        ),
      ),
    );
  }
}

// banner


// 毛玻璃效果
class FrostedDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: new FlutterLogo()
        ),
        new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                width: 200.0,
                height: 200.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)
                ),
                child: new Center(
                  child: new Text(
                      'Frosted',
                      style: Theme.of(context).textTheme.display3
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ListViewTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Center(
        child: new ListView(
          children: <Widget>[
            new Container(
              height: 80.0,
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: new List.generate(10, (int index) {
                  return new Card(
                    color: Colors.blue[index * 100],
                    child: new Container(
                      width: 50.0,
                      height: 50.0,
                      child: new Text("$index"),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


