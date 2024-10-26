import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'sign_in_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'chat_screen_2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/signin': (context) => SignInScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        // Removed static routes for ChatScreen
        // '/chat1': (context) => ChatScreen(),
        // '/chat2': (context) => ChatScreen_2(),
      },
    );
  }
}
