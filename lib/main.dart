import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/bus_controller.dart';
import 'package:student_commute/controller/user_controller.dart';
import 'package:student_commute/firebase_options.dart';
import 'package:student_commute/view/bus/bus_bottomnavigation.dart';
import 'package:student_commute/view/bus/bus_login.dart';
import 'package:student_commute/view/landing_page.dart';
import 'package:student_commute/view/splash_screen.dart';
import 'package:student_commute/view/user/user_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserController>(
          create: (context) => UserController(),
        ),
        ChangeNotifierProvider<BusController>(
          create: (context) => BusController(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Student Commute',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: DEFAULT_BLUE_DARK),
            useMaterial3: true,
          ),
          home: SpalshScreen  ()),
    );
  }
}
