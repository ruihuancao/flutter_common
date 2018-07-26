import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;


import 'home.dart';
import 'package:flutter_common/setting/setting.dart';
import 'package:flutter_common/setting/theme.dart';
import 'package:flutter_common/setting/scales.dart';

/// App
class App extends StatefulWidget {
  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {

  /// 系统设置
  Settings settings;

  @override
  void initState(){
    super.initState();
    /// 初始化设置
    settings = new Settings(
      theme: kLightTheme,
      platform: defaultTargetPlatform,
      textScaleFactor: kAllAppTextScaleValues[0],
      textDirection: TextDirection.ltr,
    );
    /// 从pref文件配置更新设置
    Settings.init().then((Settings newSettings){
      setState(() {
        settings = newSettings;
      });
    });
  }

  /// 设置配置变更
  void settingUpdate(Settings newSettings) async{
    await Settings.update(newSettings);
    setState(() {
      settings = newSettings;
    });
  }

  /// 修改字体大小
  Widget applyTextScaleFactor(Widget child) {
    return new Builder(
      builder: (BuildContext context) {
        return new MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: settings.textScaleFactor.scale,
          ),
          child: child,
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: settings.theme.data.copyWith(platform: settings.platform),
        debugShowCheckedModeBanner: true,
        builder: (BuildContext context, Widget child) {
          return new Directionality(
            // ltr lrt 支持
            textDirection: settings.textDirection,
            // 字体大小修改
            child: applyTextScaleFactor(child),
          );
        },
        home: new Scaffold(
          body: Home(settings: settings, settingUpdate: settingUpdate,)
        )
    );
  }
}
