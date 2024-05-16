import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';

class UserNotifications extends StatefulWidget {
  const UserNotifications({super.key});

  @override
  State<UserNotifications> createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('notifications').get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: size.width,
              height: size.height * 0.10,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Notifications',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recent',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No notifications available'));
                  }

                  final notifications = snapshot.data!;

                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index].data();
                      final topic = notification!['topic'] ?? 'Route Unknown';
                      final problem = notification['problem'] ?? 'N/A';
                      final busId = notification['reg_no'] ?? 'Status Unknown';
                      // final reachTime = notification['reachTime'] ?? 'Time Unknown';

                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: DEFAULT_BLUE_DARK,
                          child: Icon(
                            Iconsax.bus5,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          topic,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("($problem)"),
                            Text("$busId"),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
