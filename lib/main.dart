import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muti_store_web_app_v2/views/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid
        ? const FirebaseOptions(
            apiKey: "AIzaSyAilLWkqESC0s2RRs0q7yNs4Y7PLc0j6C8",
            authDomain: "desarrollomobile-b195d.firebaseapp.com",
            projectId: "desarrollomobile-b195d",
            storageBucket: "desarrollomobile-b195d.appspot.com",
            messagingSenderId: "904260307344",
            appId: "1:904260307344:web:79e03a1c2b07c0a5770b15",
            measurementId: "G-CT9J19VWZ9")
        : null,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}
