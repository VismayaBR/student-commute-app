import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/bus_controller.dart';
import 'package:student_commute/view/bus/bus_signup.dart';
import 'package:student_commute/view/bus/bus_bottomnavigation.dart';
import 'package:student_commute/view/bus/phonepage.dart'; // Assuming you have this file for navigation after login

class BusLogin extends StatefulWidget {
  const BusLogin({super.key});

  @override
  State<BusLogin> createState() => _BusLoginState();
}

class _BusLoginState extends State<BusLogin> {
  TextEditingController loginMobileController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginController = Provider.of<BusController>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: loginController.loginKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 300,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Welcome',
                    style: GoogleFonts.robotoSerif(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Phone',
                  style: GoogleFonts.poppins(),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: loginMobileController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "*required field";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Password',
                  style: GoogleFonts.poppins(),
                ),
                Consumer<BusController>(
                    builder: (context, obsecureController, _) {
                  return TextFormField(
                    obscureText: obsecureController.isObsecure,
                    controller: loginPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "*required field";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        isDense: true,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              obsecureController.changeObsecure();
                            },
                            icon: Icon(obsecureController.isObsecure
                                ? Iconsax.eye
                                : Iconsax.eye_slash))),
                  );
                }),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    
                  
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return PhonePage();
                        },));
                      },
                      child: Text(
                        'Forgot Password',
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      if (loginController.loginKey.currentState!.validate()) {
                        login(context, loginController);
                      }
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
                      'Login Now',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.poppins(),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BusSignUp(),
                          ));
                        },
                        child: Text(
                          'Signup Now',
                          style: GoogleFonts.poppins(color: Colors.black),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login(
      BuildContext context, BusController loginController) async {
    final QuerySnapshot<Map<String, dynamic>> busSnapshot =
        await FirebaseFirestore.instance
            .collection('bus')
            .where('phone', isEqualTo: loginMobileController.text)
            .where('password', isEqualTo: loginPasswordController.text)
            .get();

    if (busSnapshot.docs.isNotEmpty) {
      String busId = busSnapshot.docs[0].id;
      String bus = busSnapshot.docs[0]['bus'];
      String phone = busSnapshot.docs[0]['phone'];
      String reg_no = busSnapshot.docs[0]['reg_no'];
      SharedPreferences spref = await SharedPreferences.getInstance();
      spref.setString('user_id', busId);
      spref.setString('bus', bus);
      spref.setString('phone', phone);
      spref.setString('reg_no', reg_no);
      print('bus ID: $busId');
      
      // Clear the text fields after successful login
      loginMobileController.clear();
      loginPasswordController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return BusBottomNavigationBar(); // Assuming you have this page to navigate after login
        }),
      );
    } else {
      // Show an error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid phone or password'),
        ),
      );
    }
  }
}
