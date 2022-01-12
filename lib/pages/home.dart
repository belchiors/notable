import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:notable/model/note_model.dart';
import 'package:notable/model/notes_provider.dart';
import 'package:notable/pages/archive.dart';

import 'package:notable/pages/editor.dart';
import 'package:notable/pages/search.dart';
import 'package:notable/pages/settings.dart';
import 'package:notable/pages/trash.dart';

import 'package:notable/widgets/action_bar.dart';
import 'package:notable/widgets/action_button.dart';
import 'package:notable/widgets/list_item.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _selectedItems = <int>{};
  var _editMode = false;

  void _onItemTap(Note note) async {
    if (!_editMode) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Editor(note: note),
          ));
    } else if (_selectedItems.contains(note.id)) {
      setState(() {
        _selectedItems.remove(note.id);

        if (_selectedItems.isEmpty) {
          _editMode = false;
        }
      });
    } else {
      setState(() {
        _selectedItems.add(note.id!);
      });
    }
  }

  void _onItemLongPress(int id) {
    if (!_editMode) {
      setState(() {
        _editMode = true;
        _selectedItems.add(id);
      });
    }
  }

  void _onArchive() async {
    await Provider.of<NotesProvider>(context, listen: false)
        .archive(_selectedItems);
    setState(() {
      _editMode = false;
      _selectedItems.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: _selectedItems.length > 1
          ? Text('Notes archived')
          : Text('Note archived'),
    ));
  }

  void _onDelete() async {
    await Provider.of<NotesProvider>(context, listen: false)
        .moveToTrash(_selectedItems);
    setState(() {
      _editMode = false;
      _selectedItems.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: _selectedItems.length > 1
          ? Text('Notes moved to trash')
          : Text('Note moved to trash'),
    ));
  }

  void _onStartup() async {
    await Provider.of<NotesProvider>(context).deleteOldItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _onStartup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar(
        defaultAppBar: AppBar(
          title: Text('notable'),
          actions: [
            ActionButton(
              icon: Icon(FluentIcons.search_24_regular),
              onPressed: () async => showSearch(
                context: context,
                delegate: Search(
                  items:
                      await Provider.of<NotesProvider>(context, listen: false)
                          .notes,
                ),
              ),
            ),
            PopupMenuButton(
              onSelected: (int value) {
                if (value == 0) {
                  Navigator.push(context, MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => Archive(),
                  ));
                } else if (value == 1) {
                  Navigator.push(context, MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => Trash(),
                  ));
                } else if (value == 2) {
                  Navigator.push(context, MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => Settings(),
                  ));
                }
              },
              icon: Icon(FluentIcons.more_vertical_24_regular),
              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                PopupMenuItem(
                  value: 0,
                  child: Text('Archive'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('Trash'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Settings'),
                ),
              ]
            ),
          ],
        ),
        actionBarTitle: Text('${_selectedItems.length} selected'),
        display: _editMode,
        onClose: () {
          setState(() {
            _editMode = false;
            _selectedItems.clear();
          });
        },
        actions: [
          ActionButton(
            icon: Icon(FluentIcons.archive_24_regular),
            onPressed: _onArchive,
          ),
          ActionButton(
            icon: Icon(FluentIcons.delete_24_regular),
            onPressed: _onDelete,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Consumer<NotesProvider>(
          builder: (context, provider, child) => FutureBuilder<List<Note>?>(
            future: provider.notes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No notes yet',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListItem(
                    item: snapshot.data![index],
                    isSelected:
                        _selectedItems.contains(snapshot.data![index].id),
                    onTap: () => _onItemTap(snapshot.data![index]),
                    onLongPress: () =>
                        _onItemLongPress(snapshot.data![index].id!),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create a new note',
        child: Icon(FluentIcons.compose_24_regular),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Editor()));
        },
      ),
    );
  }
}
