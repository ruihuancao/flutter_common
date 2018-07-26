import 'package:flutter/material.dart';
import 'package:flutter_common/page/platform_channel.dart';
import 'package:flutter_common/widget/banner/banner.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

class DevelopPage extends StatelessWidget {

  final Color color;

  DevelopPage(this.color);

  @override
  Widget build(BuildContext context) {
    // 设置状态栏
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("测试代码"),
        centerTitle: true,
      ),
      body: Container(
        color: color,
        child: Column(
          children: <Widget>[
            BannerTest(),
            new RaisedButton(
              child: new Text("打开平台代码调用"),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlatformChannelPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// banner
class BannerTest extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      height: 256.0,
      child: BannerWidget(
          children: [
            Container(
              color: Colors.red,
              child: Center(
                child: new Text("1"),
              ),
            ),
            Container(
              color: Colors.blue,
              child: Center(
                child: new Text("2"),
              ),
            ),
            Container(
              color: Colors.green,
              child: Center(
                child: new Text("3"),
              ),
            ),
            Container(
              color: Colors.yellow,
              child: Center(
                child: new Text("4"),
              ),
            )
          ]
      ),
    );
  }
}

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


