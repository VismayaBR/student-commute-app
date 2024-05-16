import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/utils/style.dart';
import 'package:student_commute/view/bus/bus_login.dart';
import 'package:student_commute/view/user/user_login.dart';

class LandingSceen extends StatelessWidget {
  const LandingSceen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Student Commute",
            style: poppinStyle(
                fontWeight: FontWeight.w700, color: DEFAULT_BLUE_DARK),
          ),
          SizedBox(
              width: double.infinity,
              child: SvgPicture.asset("assets/Image.svg")),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const UserLogin();
                      },
                    ));
                  },
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll<OutlinedBorder>(
                          ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      minimumSize: MaterialStatePropertyAll<Size>(
                        Size.fromHeight(50),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(DEFAULT_BLUE_GREY)),
                  child: Text(
                    'User Login',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const BusLogin();
                      },
                    ));
                  },
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll<OutlinedBorder>(
                          ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      minimumSize: MaterialStatePropertyAll<Size>(
                        Size.fromHeight(50),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(DEFAULT_BLUE_DARK)),
                  child: Text(
                    'Bus Login',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
