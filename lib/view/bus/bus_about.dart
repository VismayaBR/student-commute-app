import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_commute/const.dart';

class BusAboutUs extends StatelessWidget {
  const BusAboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton.filled(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Iconsax.arrow_left,
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'StudentCommute',
                  style: GoogleFonts.poppins(
                    color: DEFAULT_BLUE_DARK,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Search your bus',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: DEFAULT_BLUE_GREY,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'About Us',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
             Align(
              alignment: Alignment.topCenter,
              child: Text(
                'More than just an app, CommuteSmart is a community of students, educators, and parents committed to transforming the student commute experience. Whether youre a high schooler or a university student, our platform supports your journey to and from school with smart technology and a heart for sustainability.Download CommuteSmart today and take the first step towards a smarter, safer, and more sustainable commute!',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
