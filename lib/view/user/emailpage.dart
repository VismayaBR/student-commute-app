import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';
import 'package:student_commute/view/user/resetpage.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController emailController = TextEditingController();

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
              const SizedBox(height: 50),
              Text('Registered Email', style: GoogleFonts.poppins()),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*required field";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 20),
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (loginController.loginKey.currentState!.validate()) {
                      checkEmailAndNavigate();
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
                    backgroundColor: MaterialStateProperty.all(DEFAULT_BLUE_DARK),
                  ),
                  child: Text('Next', style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  void checkEmailAndNavigate() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showDialog('Error', 'Please enter an email address.');
      return;
    }

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ResetPage(email: email)),
        );
      } else {
        _showDialog('Error', 'No registered user found with that email.');
      }
    } catch (error) {
      _showDialog('Error', 'Failed to fetch user data: $error');
    }
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
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
