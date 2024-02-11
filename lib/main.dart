import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'views/start_screen.dart';
import 'themes/light_theme.dart' show lightTheme;
import 'themes/dark_theme.dart' show darkTheme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      print('Caught Flutter error: ${details.exception}');
    }
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'engynear`s news',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: const StartScreen(),
    );
  }
}
