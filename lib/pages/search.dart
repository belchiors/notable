import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:notable/pages/editor.dart';
import 'package:notable/widgets/action_button.dart';

import 'package:notable/model/note_model.dart';
import 'package:notable/widgets/list_item.dart';

class Search extends SearchDelegate {
  final List<Note>? items;

  List<Note> suggestions = <Note>[];

  Search({this.items});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) return null;
    return <Widget>[
      ActionButton(
        icon: Icon(FluentIcons.dismiss_24_regular),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return ActionButton(
        icon: Icon(FluentIcons.arrow_left_24_regular),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty && query.length > 3) {
      suggestions = items!.where((item) =>
        item.title!.toLowerCase().contains(query) ||
        item.body!.toLowerCase().contains(query))
        .toList();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            if (suggestions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No items found.', style: TextStyle(fontSize: 16.0),)
                  ],
                ),
              );
            }
            return ListItem(
              item: suggestions[index],
              isSelected: false,
              onLongPress: () {},
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => Editor(note: suggestions[index]),
              )),
            );
          }),
    );
  }
}
