// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/utils/style.dart';
import 'package:student_commute/view/bus/bus_bottomnavigation.dart';
import 'package:student_commute/view/bus/bus_profile.dart';
import 'package:student_commute/view/user/user_bottom_navigation.dart';

class BusHomeScreen extends StatefulWidget {
  const BusHomeScreen({super.key});

  @override
  State<BusHomeScreen> createState() => _BusHomeScreenState();
}

class _BusHomeScreenState extends State<BusHomeScreen> {
  var topic = TextEditingController();
  var problem = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BusProfileScreen(),
                ));
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/userdp.png'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * .03,
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              height: size.height * .23,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color.fromARGB(255, 30, 129, 221),
              ),
              child: Image.asset(
                "assets/Bus1.png",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: size.height * .05,
            ),
            Text(
              "Updates",
              style: poppinStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: size.height * .02,
            ),
            Text(
              "Topic",
              style: GoogleFonts.poppins(),
            ),
            TextFormField(
              controller: topic,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Type topic...',
                hintStyle: GoogleFonts.poppins(),
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: size.height * .02,
            ),
            Text(
              "Problem",
              style: GoogleFonts.poppins(),
            ),
            TextFormField(
              controller: problem,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Type problem...',
                hintStyle: GoogleFonts.poppins(),
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: size.height * .05,
            ),
            Center(
              child: SizedBox(
                width: size.width / 2,
                child: ElevatedButton(
                  onPressed: () {
                    notifications();
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => const UserBottomNavigation(),
                    // ));
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
                    'Send',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> notifications() async {
     DateTime selectedDate = DateTime.now();
     var dt1 = DateFormat('dd MMMM yyyy').format(selectedDate);
    SharedPreferences spref = await SharedPreferences.getInstance();
    var id = spref.getString('user_id');
    var reg_no = spref.getString('reg_no');
    await FirebaseFirestore.instance.collection('notifications').add({
      'bus_id': id,
      'topic': topic.text,
      'problem': problem.text,
      'date':dt1,
      'bus_id': id,
      'reg_no':reg_no
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Schedule added successfully!')),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return BusBottomNavigationBar();
    },)); // Optionally, navigate back after adding
  }
}
