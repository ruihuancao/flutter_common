import 'package:flutter/material.dart';

import 'package:flutter_common/res/string.dart';
import 'package:flutter_common/pages/develop.dart';
import 'package:flutter_common/setting/setting.dart';
import 'package:flutter_common/components/empty_component.dart';
import 'pages/search.dart';
/// 主页面
class Home extends StatefulWidget {

  const Home({
    Key key,
    this.settings,
    this.settingUpdate
  }) : super(key: key);

  final Settings settings;
  final Function settingUpdate;

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home>{
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          EmptyComponent(),
          EmptyComponent(),
          new DevelopPage(color: Colors.blue, settings: widget.settings, settingUpdate: widget.settingUpdate,),
          SearchPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            title: new Text(AppStrings.menu_home),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(Icons.collections),
            title: new Text(AppStrings.menu_collection),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(Icons.ondemand_video),
            title: new Text(AppStrings.menu_tool),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            title: new Text(AppStrings.menu_person),
          ),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      )
    );
  }
}