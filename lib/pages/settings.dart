import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:path/path.dart' as path;

import 'package:android_intent_plus/android_intent.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notable/data/repository.dart';

import 'package:notable/model/notes_provider.dart';
import 'package:notable/preferences.dart';
import 'package:notable/widgets/action_button.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ActionButton(
          icon: Icon(FluentIcons.dismiss_24_regular),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings'),
      ),
      body: Consumer<UserPreferences>(
        builder: (context, provider, child) => Container(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Appearance',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    ListTile(
                      title: Text('Dark theme'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      trailing: Switch(
                          value: provider.isDarkTheme,
                          onChanged: (value) {
                            setState(() {
                              provider.switchTheme(value);
                            });
                          }),
                      onTap: () {
                        setState(() {
                          var value = !provider.isDarkTheme;
                          provider.switchTheme(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: null),
              Container(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text('About',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    ListTile(
                      title: Text('Send feedback'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Rate on Play Store'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
