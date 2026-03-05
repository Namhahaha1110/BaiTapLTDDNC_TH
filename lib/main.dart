import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'state/session.dart';
import 'page/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final session = Session();
  await session.init();
  runApp(MyApp(session: session));
}

class MyApp extends StatelessWidget {
  final Session session;
  const MyApp({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return SessionScope(
      notifier: session,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
      ),
    );
  }
}
