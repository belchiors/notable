import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notable/model/note_model.dart';
import 'package:notable/model/notes_provider.dart';
import 'package:notable/widgets/action_bar.dart';
import 'package:notable/widgets/action_button.dart';
import 'package:notable/widgets/list_item.dart';

class Archive extends StatefulWidget {
  const Archive({Key? key}) : super(key: key);

  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  bool _editMode = false;
  var _selectedItems = <int>{};

  void _onItemTap(Note note) async {
    if (!_editMode) {
      return;
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

  void _onUnarchive() async {
    await Provider.of<NotesProvider>(context, listen: false)
        .unarchive(_selectedItems);
    setState(() {
      _editMode = false;
      _selectedItems.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: _selectedItems.length > 1
          ? Text('Notes unarchived')
          : Text('Note unarchived'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar(
        defaultAppBar: AppBar(
          leading: Builder(
            builder: (context) => ActionButton(
              icon: Icon(FluentIcons.dismiss_24_regular),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Text('Archive'),
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
            icon: Icon(FluentIcons.folder_arrow_up_24_regular),
            onPressed: _onUnarchive,
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
            future: provider.archived,
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
    );
  }
}
