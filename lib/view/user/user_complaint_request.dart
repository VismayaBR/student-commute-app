import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';

class UserComplaintRequest extends StatelessWidget {
  const UserComplaintRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Complaint Request',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No complaints found'));
                  } else {
                    final complaints = snapshot.data!;
                    return ListView.builder(
                      itemCount: complaints.length,
                      itemBuilder: (context, index) {
                        final complaint = complaints[index].data()!;
                        return ListTile(
                          leading: const CircleAvatar(),
                          title: Text(
                            complaint['complaint'] ?? 'Unknown User',
                            style: GoogleFonts.poppins(),
                          ),
                          trailing: Text(
                            complaint['reg_no'] ?? 'Unknown bus',
                            style: GoogleFonts.poppins(),
                          ),
                          subtitle: complaint['status']=='0'?Text(
                            'complaint pending',
                            style: GoogleFonts.poppins(),
                          ): complaint['status']=='1'?Text(
                            'complaint accepted',
                            style: GoogleFonts.poppins(),
                          ):Text(
                            'complaint Rejected',
                            style: GoogleFonts.poppins(),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var id = spref.getString('user_id');
    if (id == null) {
      return [];
    }

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('complaints')
              .where('user_id', isEqualTo: id)
              .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
