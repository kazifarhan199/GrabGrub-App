import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:grab_grub_app/screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MyThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.grey,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      background: Colors.white,
      onBackground: Colors.grey,
      primary: Colors.grey,
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.grey,
      error: Colors.red,
      surface: Colors.white,
      onSurface: Colors.grey,
      errorContainer: Colors.grey,
      onError: Colors.black,
    ),
    iconTheme: IconThemeData(color: Colors.grey),
    inputDecorationTheme: InputDecorationTheme(
        focusColor: Colors.grey,
        fillColor: Colors.grey,
        hoverColor: Colors.grey,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
      overlayColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(255, 210, 210, 210)),
    )),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        focusColor: Colors.white,
        splashColor: Colors.white),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.grey, fontSize: 25.0),
        iconTheme: IconThemeData(color: Colors.grey)),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.grey,
      cursorColor: Colors.grey,
      selectionHandleColor: Colors.grey,
    ),
    backgroundColor: Colors.white,
    highlightColor: Colors.white,
  );
}
