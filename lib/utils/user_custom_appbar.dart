import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_commute/const.dart';

class UserCustomAppBar extends StatelessWidget {
  const UserCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
