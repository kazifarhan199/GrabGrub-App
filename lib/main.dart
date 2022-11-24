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
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.grey),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.grey[400], focusColor: Colors.grey[700]),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 25.0),
            iconTheme: IconThemeData(color: Colors.grey)),
      ),
      home: Wrapper(),
    );
  }
}
