import 'package:flutter/material.dart';
import 'custom_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'sign_in_flow/auth_state_switch.dart';
import 'widgets/page_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: customViolet,
        scaffoldBackgroundColor: backgroundPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthStateSwitch(app: PageWrapper()),
    );
  }
}
