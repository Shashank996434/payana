import 'package:cproject/user/menuprofile.dart';
import 'package:cproject/user/create_your_profile.dart';
import 'package:cproject/pages/vehicallist.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:cproject/pages/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyCu3mvQsCvLeW9BFZ7TRt2FuMN_W0T3rLM", appId: "1:11516328235:android:73d7ffac2ae9372fe76d6e",
        messagingSenderId:"11516328235", projectId: "payana-50f48"),
  ):await Firebase.initializeApp();
  runApp(const MyApp(

  ));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      /*initialRoute: '/',
      routes: {
        '/': (context) => const SignUp(),
        '/login': (context) => const LogIn(),
        '/home': (context) => const Home(),
      },*/
       home: EditWidget()
        //home: Details09ReviWidget()
        //home:Details09ReviWidget()
       // home: Profile05Widget ()
      //home: HomeScreen(),
      //home: VehicleListScreen(),
    );
  }
}



