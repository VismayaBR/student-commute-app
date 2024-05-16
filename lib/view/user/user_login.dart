import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';
import 'package:student_commute/view/user/emailpage.dart';
import 'package:student_commute/view/user/user_bottom_navigation.dart';
import 'package:student_commute/view/user/user_home.dart';
import 'package:student_commute/view/user/user_signup.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  var email = TextEditingController();
  var password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginController = Provider.of<UserController>(context, listen: false);
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
                  'Email',
                  style: GoogleFonts.poppins(),
                ),
                TextFormField(
                  controller: email,
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
                Consumer<UserController>(
                    builder: (context, obsecureController, _) {
                  return TextFormField(
                    obscureText: obsecureController.isObsecure,
                    controller: password,
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
                          return EmailPage();
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
                        userlogin(
                         email,
                          password,
                        );
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
                            builder: (context) => const UserSignup(),
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

  Future<void> userlogin(email, password) async {
    final QuerySnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email.text)
            .where('password', isEqualTo: password.text)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
      String userId = userSnapshot.docs[0].id;
       String name = userSnapshot.docs[0]['name'];
        String email = userSnapshot.docs[0]['email'];
         String phone = userSnapshot.docs[0]['phone'];
      SharedPreferences spref = await SharedPreferences.getInstance();
      spref.setString('user_id', userId);
      spref.setString('name',name );
      spref.setString('email', email);
      spref.setString('phone', phone);
      print('Customer ID: $userId');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return UserBottomNavigation();
      }));
    } 
  }
}
