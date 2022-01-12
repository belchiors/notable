import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'package:notable/model/notes_provider.dart';
import 'package:notable/model/note_model.dart';
import 'package:notable/widgets/action_button.dart';

class Editor extends StatefulWidget {
  final Note? note;
  Editor({Key? key, this.note}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleCtrl.text = widget.note!.title!;
      _bodyCtrl.text = widget.note!.body!;
    }
    super.initState();
  }

  void addNew() {
    if (_titleCtrl.text.isNotEmpty || _bodyCtrl.text.isNotEmpty) {
      var newNote = Note(
        id: widget.note?.id,
        title: _titleCtrl.text,
        body: _bodyCtrl.text,
        created: widget.note?.created ?? DateTime.now(),
        edited: DateTime.now()
      );
      Provider.of<NotesProvider>(context, listen: false).addNew(newNote);
    }
  }

  void _onSave() {
    addNew();
    _titleCtrl.clear();
    _bodyCtrl.clear();
  }

  void _onDelete() {
    if (widget.note != null) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Provider.of<NotesProvider>(context, listen: false)
          .moveToTrash(<int>{widget.note!.id!});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Note moved to trash'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No items to delete'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onSave();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: ActionButton(
              icon: Icon(FluentIcons.arrow_left_24_regular),
              onPressed: () {
                _onSave();
                Navigator.pop(context);
              }),
          actions: [
            PopupMenuButton(
              onSelected: (int value) {
                if (value == 0) {
                  Share.share(_bodyCtrl.text);
                } else if (value == 1) {
                  Clipboard.setData(ClipboardData(text: _bodyCtrl.text));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Copied to clipboard'),
                  ));
                } else if (value == 2) {
                  _onDelete();
                }
              },
              icon: Icon(FluentIcons.more_vertical_24_regular),
              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                    PopupMenuItem(
                      value: 0,
                      child: Text('Share'),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text('Copy'),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text('Delete'),
                    ),
                  ]),
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              TextField(
                textInputAction: TextInputAction.next,
                controller: _titleCtrl,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _bodyCtrl,
                  focusNode: null,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Note',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
