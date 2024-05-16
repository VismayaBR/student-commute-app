import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ProfileTiles extends StatelessWidget {
  final String title;
  final Widget page;
  const ProfileTiles({
    required this.title,
    required this.page,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => page,
          ));
        },
        title: Text(
          title,
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        trailing: const Icon(
          Iconsax.arrow_right,
          color: Colors.grey,
        ),
      ),
    );
  }
}
