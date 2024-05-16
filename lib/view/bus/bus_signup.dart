import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/bus_controller.dart';
import 'package:student_commute/view/bus/bus_bottomnavigation.dart';
import 'package:student_commute/view/bus/bus_login.dart';

class BusSignUp extends StatefulWidget {
  const BusSignUp({super.key});

  @override
  State<BusSignUp> createState() => _BusSignUpState();
}

class _BusSignUpState extends State<BusSignUp> {
  var phone = TextEditingController();
  var name = TextEditingController();
  var bus = TextEditingController();
  var regno = TextEditingController();
  var password = TextEditingController();
  var cpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final signupController = Provider.of<BusController>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: signupController.signUpKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 150,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Create a New Account with us!',
                    style: GoogleFonts.robotoSerif(
                        fontSize: 20, fontWeight: FontWeight.w600),
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
                  controller: phone,
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
                  'Owner Name',
                  style: GoogleFonts.poppins(),
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: name,
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
                  'Bus Name',
                  style: GoogleFonts.poppins(),
                ),
                TextFormField(
                  controller: bus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "*required field";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Registration Number',
                  style: GoogleFonts.poppins(),
                ),
                TextFormField(
                  controller: regno,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "*required field";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<BusController>(
                    builder: (context, obsecureController, _) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password',
                          style: GoogleFonts.poppins(),
                        ),
                        TextFormField(
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
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Confirm Password',
                          style: GoogleFonts.poppins(),
                        ),
                        TextFormField(
                            obscureText: obsecureController.isObsecure,
                            controller: cpassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "*required field";
                              } else if (value != password.text) {
                                return "*Password did not match";
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
                                        : Iconsax.eye_slash))))
                      ]);
                }),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Consumer<BusController>(
                        builder: (context, checkController, _) {
                      return Checkbox(
                        value: checkController.isConditionsVerified,
                        onChanged: (value) {
                          checkController.changeCondition(value!);
                        },
                      );
                    }),
                    Text(
                      'I agree to Terms and Conditions',
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<BusController>(
                    builder: (context, buttonController, _) {
                  return SizedBox(
                    width: size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (signupController.signUpKey.currentState!
                            .validate()) {
                          if (buttonController.isConditionsVerified) {
                            postData();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                              return BusLogin();
                            },));
                          } else {
                            CherryToast.info(
                              title: Text(
                                'Agree?',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                              description: Text(
                                'Please agree to Terms and Conditions to continue',
                                style: GoogleFonts.poppins(),
                              ),
                            ).show(context);
                          }
                        }
                      },
                      style: ButtonStyle(
                          shape: const MaterialStatePropertyAll<OutlinedBorder>(
                              ContinuousRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)))),
                          minimumSize: const MaterialStatePropertyAll<Size>(
                            Size.fromHeight(50),
                          ),
                          backgroundColor: buttonController.isConditionsVerified
                              ? const MaterialStatePropertyAll(
                                  DEFAULT_BLUE_GREY)
                              : const MaterialStatePropertyAll(Colors.grey)),
                      child: Text(
                        'Signup Now',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.poppins(),
                    ),
                    TextButton(
                        onPressed: () {
                          // Navigate to login page
                        },
                        child: Text(
                          'Login Now',
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

  Future<void> postData() async {
    await FirebaseFirestore.instance.collection('bus').add({
      'phone': phone.text,
      'name': name.text,
      'bus': bus.text,
      'reg_no': regno.text,
      'password': password.text,
    });
    phone.clear();
    name.clear();
    bus.clear();
    regno.clear();
    password.clear();
  }
}
