import 'package:chatting/screens/chat_screen.dart';
import 'package:chatting/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String? error;
  MyApp({this.error});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlutterChat',
        themeMode: ThemeMode.light,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Color.fromARGB(255, 238, 198, 246),
          primaryColor: Colors.deepPurple,
          splashColor: Colors.pink,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple),
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.deepPurple,
          appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              SplashScreen();
            }

            if (snapshot.hasData) {
              return ChatScreen();
            }

            return AuthScreen();
          },
        ));
  }
}
