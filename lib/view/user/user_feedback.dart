import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';
import 'package:student_commute/view/user/user_bottom_navigation.dart';

class UserFeedBack extends StatefulWidget {
  const UserFeedBack({super.key});

  @override
  State<UserFeedBack> createState() => _UserFeedBackState();
}

class _UserFeedBackState extends State<UserFeedBack> {
  var feedback = TextEditingController();
  var rating;
 Future<void> addData(BuildContext context) async {
       SharedPreferences spref = await SharedPreferences.getInstance();
     var id = spref.getString('user_id');
      var username = spref.getString('name');
    await FirebaseFirestore.instance.collection('feedback').add({
      'feedback': feedback.text,
      'rating': rating,
      'userId': id,
      'userName': username,
      
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Schedule added successfully!')),
    );
    Navigator.of(context).pop(); // Optionally, navigate back after adding
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton.filled(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Iconsax.arrow_left,
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: feedback,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type feedback...',
                  hintStyle: GoogleFonts.poppins(),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<UserController>(builder: (context, ratingController, _) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: RatingStars(
                    value: ratingController.ratingStar,
                    maxValue: 5,
                    starColor: Colors.amber,
                    onValueChanged: (value) {
                      ratingController.changeRating(value);
                      setState(() {
                        rating = value;
                      });

                    },
                  ),
                );
              }),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: size.width / 2,
                child: ElevatedButton(
                  onPressed: () {
                    addData(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserBottomNavigation(),
                    ));
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
            ],
          ),
        ),
      ),
    );
  }
}
