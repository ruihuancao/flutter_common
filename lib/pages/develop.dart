import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_common/components/platform_channel_test.dart';
import 'package:flutter_common/components/banner_test.dart';
import 'package:flutter_common/components/settings_test.dart';
import 'package:flutter_common/setting/setting.dart';
import 'package:flutter_common/components/test.dart';
import 'package:flutter_common/widget/video/simple_video_player.dart';

/// 开发测试页面
class DevelopPage extends StatelessWidget {
  final _SearchDemoSearchDelegate _delegate = new _SearchDemoSearchDelegate();

  final Color color;
  final Settings settings;
  final Function settingUpdate;

  DevelopPage({this.color, this.settings, this.settingUpdate});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("测试代码"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch<int>(
                context: context,
                delegate: _delegate,
              );
            },
          )
        ],
      ),
      body: Container(
        color: color,
        child: ListView(
          children: <Widget>[
            BannerTest(),
            PlatformChannelTest(),
            SettingsTest(settings, settingUpdate),
            TestItem(text: "全屏播放视频", result: "", onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoFullPage('https://youku.cdn-56.com/20180622/3878_d3968706/index.m3u8',)),
              );
            }),
          ],
        ),
      ),
    );
  }
}


// banner
class _SearchDemoSearchDelegate extends SearchDelegate<int> {
  final List<String> _history = <String>["ada", "bfd", "dsd", "tes", "dev"];

  @override
  Widget buildLeading(BuildContext context) {
    return new IconButton(
      icon: new AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return new _SuggestionList(
      query: query,
      suggestions: _history.where((String history) => history.startsWith(query)).toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return new Center(
      child: new Text(query),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      new IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return new ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: new RichText(
            text: new TextSpan(
              text: suggestion.substring(0, query.length),
              style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                new TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
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


