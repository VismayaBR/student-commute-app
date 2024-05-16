import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/bus_controller.dart';
import 'package:student_commute/controller/user_controller.dart';
import 'package:student_commute/utils/profile_tiles.dart';
import 'package:student_commute/view/bus/bus_about.dart';
import 'package:student_commute/view/bus/bus_addschedule.dart';
import 'package:student_commute/view/bus/bus_changepassword.dart';
import 'package:student_commute/view/bus/bus_faredetails.dart';
import 'package:student_commute/view/splash_screen.dart';
import 'package:student_commute/view/user/user_about_us.dart';
import 'package:student_commute/view/user/user_change_password.dart';
import 'package:student_commute/view/user/user_complaint_registration.dart';
import 'package:student_commute/view/user/user_complaint_request.dart';
import 'package:student_commute/view/user/user_fare_details.dart';

class BusProfileScreen extends StatefulWidget {
  const BusProfileScreen({super.key});

  @override
  State<BusProfileScreen> createState() => _BusProfileScreenState();
}

class _BusProfileScreenState extends State<BusProfileScreen> {
  var name;
  var phone;
  Future<void> data() async {
     SharedPreferences spref = await SharedPreferences.getInstance();
     setState(() {
        name = spref.getString('bus');
      phone = spref.getString('phone');
     });
     
  }
  @override
  void initState() {
    data();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profileController =
        Provider.of<BusController>(context, listen: false);
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
                IconButton.filled(
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
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  // const ProfileTiles(
                  //   title: 'Change Password',
                  //   page: BusChangePassword(),
                  // ),
                  // const ProfileTiles(
                  //   title: 'Call Support',
                  //   page: UserCallSupport(),
                  // ),
                  const ProfileTiles(
                    title: 'About Us',
                    page: BusAboutUs(),
                  ),

                  const ProfileTiles(
                    title: 'Fare Details',
                    page: BusFareDetails(),
                  ),
                   ProfileTiles(
                    title: 'Add Schedule',
                    page: BusAddScheduleScrren(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width / 2,
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then(
                            (value) => Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const SpalshScreen(),
                                ),
                                (route) => false));
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
                        'Logout',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
