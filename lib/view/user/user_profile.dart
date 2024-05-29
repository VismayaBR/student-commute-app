import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/utils/profile_tiles.dart';
import 'package:student_commute/view/landing_page.dart';
import 'package:student_commute/view/user/user_about_us.dart';
import 'package:student_commute/view/user/user_change_password.dart';
import 'package:student_commute/view/user/user_complaint_registration.dart';
import 'package:student_commute/view/user/user_complaint_request.dart';
import 'package:student_commute/view/user/user_fare_details.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = 'Guest';
  String email = 'Not Available';
  String phone = 'Not Available';
  String id = '';
  File? _profileImage;

  Future<void> getData() async {
    try {
      SharedPreferences spref = await SharedPreferences.getInstance();
      setState(() {
        id = spref.getString('user_id') ?? '';
        name = spref.getString('name') ?? 'Guest';
        email = spref.getString('email') ?? 'Not Available';
        phone = spref.getString('phone') ?? 'Not Available';
      });
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _showEditDialog() {
    final TextEditingController nameController = TextEditingController(text: name);
    final TextEditingController emailController = TextEditingController(text: email);
    final TextEditingController phoneController = TextEditingController(text: phone);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : AssetImage('assets/default_avatar.png') as ImageProvider,
                    child: _profileImage == null
                        ? Icon(
                            Iconsax.camera,
                            size: 40,
                            color: Colors.grey[400],
                          )
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                  phone = phoneController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: size.height / 3.5,
            width: size.width,
            decoration: const BoxDecoration(color: DEFAULT_BLUE_DARK),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Iconsax.arrow_left,
                    color: Colors.white,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : AssetImage('assets/default_avatar.png') as ImageProvider,
                    ),
                    SizedBox(width: 10), // Added spacing for better alignment
                    IconButton(
                      onPressed: _showEditDialog,
                      icon: Icon(
                        Iconsax.edit,
                        size: size.height * 0.02,
                        color: DEFAULT_BLUE_GREY,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        Text(
                          phone,
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const ProfileTiles(
                    title: 'Change Password',
                    page: UserChangePassword(),
                  ),
                  const ProfileTiles(
                    title: 'About Us',
                    page: UserAboutUs(),
                  ),
                  const ProfileTiles(
                    title: 'Complaint Registration',
                    page: UserComplaintRegistration(),
                  ),
                  const ProfileTiles(
                    title: 'Complaint Request',
                    page: UserComplaintRequest(),
                  ),
                  const ProfileTiles(
                    title: 'Fare Details',
                    page: UserFareDetails(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: size.width / 2,
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then(
                          (value) => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LandingSceen(),
                            ),
                            (route) => false,
                          ),
                        );
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          ContinuousRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size.fromHeight(35),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(DEFAULT_BLUE_DARK),
                      ),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
