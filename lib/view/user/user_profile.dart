import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';
import 'package:student_commute/utils/profile_tiles.dart';
import 'package:student_commute/view/landing_page.dart';
import 'package:student_commute/view/splash_screen.dart';
import 'package:student_commute/view/user/user_about_us.dart';
import 'package:student_commute/view/user/user_change_password.dart';
import 'package:student_commute/view/user/user_complaint_registration.dart';
import 'package:student_commute/view/user/user_complaint_request.dart';
import 'package:student_commute/view/user/user_fare_details.dart';
import 'package:student_commute/view/user/user_login.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var name;
  var email;
  var phone;
  var id;
  Future<void> getData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    setState(() {
      id = spref.getString('user_id');
      name = spref.getString('name');
      email = spref.getString('email');
      phone = spref.getString('phone');
    });
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final profileController = Provider.of<UserController>(context);

 

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
                    const CircleAvatar(
                      radius: 30,
                    ),
                    IconButton(
                      onPressed: () {},
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
                        builder: (context) =>  LandingSceen(),
                      ),
                      (route) => false,
                      )
                      );
                      },
                      
                      // 
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
