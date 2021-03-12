import 'package:cskitchen/src/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/screens/appRoot.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cskitchen/router.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Cskitchen());
}

class Cskitchen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cs kitchen',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          color: Color(0xFFE34343),
        ),
        accentColor: Colors.redAccent,
      ),
      home: AppRoot(
        auth: Auth(),
      ),
      onGenerateRoute: router.generateRoute,
    );
  }
}
