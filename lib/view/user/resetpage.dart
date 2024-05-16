import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';
import 'package:student_commute/view/landing_page.dart';
import 'package:student_commute/view/user/user_bottom_navigation.dart';
import 'package:student_commute/view/user/user_home.dart';
import 'package:student_commute/view/user/user_signup.dart';

class ResetPage extends StatefulWidget {
  String email;
  ResetPage({super.key, required this.email});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            
              const SizedBox(
                height: 50,
              ),
              Text(
                'New Password',
                style: GoogleFonts.poppins(),
              ),
              TextFormField(
                controller: password,
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
              
           
              Row(
                children: [
                
                  const Spacer(),
                 
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
                    FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: widget.email)
                      .get()
                      .then((querySnapshot) {
                    if (querySnapshot.docs.isNotEmpty) {
                      querySnapshot.docs.first.reference.update({
                        'password': password
                            .text // Storing passwords in plain text is bad practice!
                      }).then((_) {
                        _showDialog('Password Reset',
                            'Your password has been successfully reset.');
                      }).catchError((error) {
                        _showDialog(
                            'Error', 'Failed to update password: $error');
                      });
                    } else {
                      _showDialog('Error', 'No user found with this email.');
                    }
                  });
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
                height: 150,
              ),
             
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                return LandingSceen();
              },), (route) => false);
            }
          ),
        ],
      ),
    );
  }

}
