import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final signupController = Provider.of<UserController>(context, listen: false);

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
                const SizedBox(height: 150),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Create a New Account with us!',
                    style: GoogleFonts.robotoSerif(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 50),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  validator: (value) => _requiredFieldValidator(value),
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: nameController,
                  label: 'Full Name',
                  validator: (value) => _requiredFieldValidator(value),
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: phoneController,
                  label: 'Phone',
                  keyboardType: TextInputType.phone,
                  validator: (value) => _requiredFieldValidator(value),
                ),
                const SizedBox(height: 10),
                Consumer<UserController>(builder: (context, obsecureController, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPasswordField(
                        controller: passwordController,
                        label: 'Password',
                        obsecureController: obsecureController,
                        validator: (value) => _requiredFieldValidator(value),
                      ),
                      const SizedBox(height: 10),
                      _buildPasswordField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        obsecureController: obsecureController,
                        validator: (value) => _confirmPasswordValidator(
                            value, passwordController.text),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 10),
                Consumer<UserController>(builder: (context, checkController, _) {
                  return Row(
                    children: [
                      Checkbox(
                        value: checkController.isConditionsVerified,
                        onChanged: (value) {
                          checkController.changeCondition(value!);
                        },
                      ),
                      Text('I agree to Terms and Conditions',
                          style: GoogleFonts.poppins()),
                    ],
                  );
                }),
                const SizedBox(height: 10),
                Consumer<UserController>(builder: (context, buttonController, _) {
                  return SizedBox(
                    width: size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (buttonController.signUpKey.currentState!.validate()) {
                          if (buttonController.isConditionsVerified) {
                            await _signUp(context, signupController);
                          } else {
                            _showToast(context, 'Agree?',
                                'Please agree to Terms and Conditions to continue');
                          }
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(
                          const Size.fromHeight(50),
                        ),
                        backgroundColor: buttonController.isConditionsVerified
                            ? MaterialStateProperty.all(DEFAULT_BLUE_GREY)
                            : MaterialStateProperty.all(Colors.grey),
                      ),
                      child: Text(
                        'Signup Now',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: GoogleFonts.poppins()),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Login Now',
                          style: GoogleFonts.poppins(color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins()),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required UserController obsecureController,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins()),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obsecureController.isObsecure,
          decoration: InputDecoration(
            isDense: true,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: () {
                obsecureController.changeObsecure();
              },
              icon: Icon(obsecureController.isObsecure
                  ? Iconsax.eye
                  : Iconsax.eye_slash),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _signUp(BuildContext context, UserController signupController) async {
    try {
      final user = {
        'email': signupController.signupEmailController.text,
        'name': signupController.signupuserNameController.text,
        'phone': signupController.signupPhoneController.text,
        'password': signupController.signupPasswordController.text,
      };

      await FirebaseFirestore.instance.collection('users').add(user);

      _showToast(context, 'Success!', 'Account created successfully!');
      
      // Clear the text fields
      signupController.signupEmailController.clear();
      signupController.signupuserNameController.clear();
      signupController.signupPhoneController.clear();
      signupController.signupPasswordController.clear();
      signupController.signupConfrmPasswordController.clear();
      
      Navigator.of(context).pop();
    } catch (e) {
      _showToast(context, 'Error!', 'Failed to create account: $e');
    }
  }

  void _showToast(BuildContext context, String title, String description) {
    CherryToast.info(
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      description: Text(
        description,
        style: GoogleFonts.poppins(),
      ),
    ).show(context);
  }

  String? _requiredFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "*required field";
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "*required field";
    } else if (value != password) {
      return "*Password did not match";
    }
    return null;
  }
}
