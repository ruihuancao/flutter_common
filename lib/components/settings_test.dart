import 'package:flutter/material.dart';
import 'package:flutter_common/setting/setting.dart';
import 'package:flutter_common/components/test.dart';
import 'package:flutter_common/setting/theme.dart';
/// 设置页面
class SettingsTest extends StatelessWidget {

  final Settings settings;
  final Function settingChange;

  SettingsTest(this.settings, this.settingChange);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TestItem(text: "夜间模式", result: settings.theme.name, onPressed: (){
            if(settings.theme.name == "Dark"){
              settingChange(settings.copyWith(theme: kLightTheme));
            }else{
              settingChange(settings.copyWith(theme: kDarkTheme));
            }
          },),
          TestItem(text: "TextDirection", result: settings.textDirection.toString(), onPressed: (){
            if(settings.textDirection == TextDirection.ltr){
              settingChange(settings.copyWith(textDirection: TextDirection.rtl));
            }else{
              settingChange(settings.copyWith(textDirection: TextDirection.ltr));
            }
          },),
        ],
      )
    );
  }
}




