import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/utils/style.dart';
import 'package:student_commute/view/landing_page.dart';
import 'package:student_commute/view/user/user_bottom_navigation.dart';

class SpalshScreen extends StatelessWidget {
  const SpalshScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3)).then(
      (value) {
        if (FirebaseAuth.instance.currentUser == null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LandingSceen(),
              ),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => UserBottomNavigation(),
              ),
              (route) => false);
        }
      },
    );
    return Scaffold(
      backgroundColor: DEFAULT_BLUE_DARK,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/logo.svg"),
            Text(
              "Student Commute",
              style: poppinStyle(color: WHITE, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
