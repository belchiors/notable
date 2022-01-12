import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notable/model/notes_provider.dart';
import 'package:notable/pages/home.dart';
import 'package:notable/preferences.dart';
import 'package:notable/theme/theme.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NotesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserPreferences(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserPreferences>(
        builder: (context, provider, child) => MaterialApp(
              title: 'notable',
              home: Home(),
              theme: CustomTheme.lightTheme,
              darkTheme: CustomTheme.darkTheme,
              themeMode: provider.themeMode,
            ));
  }
}
