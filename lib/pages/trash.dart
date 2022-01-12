import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notable/model/note_model.dart';
import 'package:notable/model/notes_provider.dart';
import 'package:notable/widgets/action_bar.dart';
import 'package:notable/widgets/action_button.dart';
import 'package:notable/widgets/list_item.dart';

class Trash extends StatefulWidget {
  const Trash({Key? key}) : super(key: key);

  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  bool _editMode = false;
  bool _isEmpty = true;
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

  void _onRestore() async {
    await Provider.of<NotesProvider>(context, listen: false)
        .restore(_selectedItems);
    Provider.of<NotesProvider>(context, listen: false).deleted.then((notes) {
      if (notes!.isEmpty) {
        setState(() {
          _isEmpty = true;
        });
      }
    });
    setState(() {
      _editMode = false;
      _selectedItems.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: _selectedItems.length > 1
          ? Text('Notes restored')
          : Text('Note restored'),
    ));
  }

  void _onEmptyTrash() async {
    await Provider.of<NotesProvider>(context, listen: false).emptyTrash();
    setState(() {
      _editMode = false;
      _isEmpty = true;
      _selectedItems.clear();
    });
  }

  void _onStartup() async {
    await Provider.of<NotesProvider>(context).deleteOldItems();
  }

  @override
  void initState() {
    Provider.of<NotesProvider>(context, listen: false).deleted.then((notes) {
      if (notes!.isNotEmpty) {
        setState(() {
          _isEmpty = false;
        });
      }
    });
    Future.delayed(Duration.zero, _onStartup);
    super.initState();
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
                  )),
          title: Text('Trash'),
          actions: _isEmpty
              ? []
              : [
                  ActionButton(
                    icon: Icon(FluentIcons.delete_dismiss_24_regular),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text('Permanently delete all notes?'),
                          shape: Theme.of(context).dialogTheme.shape,
                          contentPadding: EdgeInsets.all(16.0),
                          actions: [
                            TextButton(
                                child: Text('Cancel'),
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel')),
                            TextButton(
                              child: Text('Confirm'),
                              onPressed: () {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                _onEmptyTrash();
                              },
                            ),
                          ],
                        ),
                      );
                    },
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
              icon: Icon(FluentIcons
                  .folder_arrow_up_24_regular), // Icon(FluentIcons.delete_off_24_regular),
              onPressed: _onRestore),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Consumer<NotesProvider>(
          builder: (context, provider, child) => FutureBuilder<List<Note>?>(
            future: provider.deleted,
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
