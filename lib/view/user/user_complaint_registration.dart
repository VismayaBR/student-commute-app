import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/view/user/user_profile.dart';

class UserComplaintRegistration extends StatefulWidget {
  const UserComplaintRegistration({super.key});

  @override
  State<UserComplaintRegistration> createState() => _UserComplaintRegistrationState();
}

class _UserComplaintRegistrationState extends State<UserComplaintRegistration> {
  var no = TextEditingController();
  var complaint = TextEditingController();
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
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Complaint Registration',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Enter Vehicle Number',
                style: GoogleFonts.poppins(),
              ),
              TextFormField(
                controller: no,
                decoration: InputDecoration(
                  hintText: 'KL 11 AA 0000',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Complaint',
                style: GoogleFonts.poppins(),
              ),
              TextFormField(
                controller: complaint,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type Complaint...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      postComplaint();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => UserProfile(),
                          ),
                          (route) => false);
                    },
                    style: const ButtonStyle(
                        shape: MaterialStatePropertyAll<OutlinedBorder>(
                          ContinuousRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                        minimumSize: MaterialStatePropertyAll<Size>(
                          Size.fromHeight(35),
                        ),
                        backgroundColor:
                            MaterialStatePropertyAll(DEFAULT_BLUE_DARK)),
                    child: Text(
                      'Request',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> postComplaint() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var id = spref.getString('user_id');
    var name = spref.getString('name');
      await FirebaseFirestore.instance.collection('complaints').add({
      
      'reg_no': no.text,
      'complaint': complaint.text,
      'user_id': id,
      'status':"0",
      'username':name
    });
  }
}
