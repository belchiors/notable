import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTheme {
  static ThemeData? get lightTheme {
    return ThemeData(
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.transparent,
      brightness: Brightness.light,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xff3f3f3f),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xff333333),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xff333333),
        elevation: 1.25,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        behavior: SnackBarBehavior.floating,
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      cardTheme: CardTheme(
        color: Color(0xfff5f5f5),
        elevation: 0.0,
        shadowColor: null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      listTileTheme: ListTileThemeData(
        selectedTileColor: Color(0xfff5f5f5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xff333333),
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xfff5f5f5),
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark),
      ),
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
    );
  }

  static ThemeData? get darkTheme {
    return ThemeData(
      canvasColor: Color(0xff202125),
      scaffoldBackgroundColor: Color(0xff202125),
      splashColor: Colors.transparent,
      brightness: Brightness.dark,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white,
        elevation: 1.25,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        behavior: SnackBarBehavior.floating,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: Color(0xff202125),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Color(0xff202125),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      cardTheme: CardTheme(
        color: Color(0xff3b3c3e),
        elevation: 0.0,
        shadowColor: null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      listTileTheme: ListTileThemeData(
        selectedTileColor: Color(0xff3b3c3e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xff202125),
          statusBarColor: Color(0xff202125),
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light),
      ),
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}
