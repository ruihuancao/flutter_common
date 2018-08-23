import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final _SearchDemoSearchDelegate _delegate = new _SearchDemoSearchDelegate();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
      title: new Text("Search"),
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
    ));
  }
}

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
      suggestions: _history
          .where((String history) => history.startsWith(query))
          .toList(),
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
              style:
                  theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
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
