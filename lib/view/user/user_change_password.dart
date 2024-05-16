import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/view/user/reset.dart';

class UserChangePassword extends StatefulWidget {
  const UserChangePassword({super.key});

  @override
  State<UserChangePassword> createState() => _UserChangePasswordState();
}

class _UserChangePasswordState extends State<UserChangePassword> {
  var email = TextEditingController();
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
                'Change Password',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 150,
            ),
            Text(
              'Enter your Email',
              style: GoogleFonts.poppins(),
            ),
            TextFormField(
              controller: email,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: size.width / 2,
                child: ElevatedButton(
                  onPressed: () {
                     checkEmailAndNavigate(email.text);
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(
                    //       builder: (context) => const UserLogin(),
                    //     ),
                    //     (route) => false);
                  },
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll<OutlinedBorder>(
                          ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      minimumSize: MaterialStatePropertyAll<Size>(
                        Size.fromHeight(35),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(DEFAULT_BLUE_DARK)),
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
    void checkEmailAndNavigate(email) async {
    // Make sure you're using the text from the controller
    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please enter an email address."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Reset(email:email)), // Assuming NextPage is defined
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("No registered user found with that email."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
