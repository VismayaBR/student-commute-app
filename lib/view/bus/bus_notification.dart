import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_commute/const.dart';

class BusNotificationScreen extends StatefulWidget {
  const BusNotificationScreen({super.key});

  @override
  State<BusNotificationScreen> createState() => _BusNotificationScreenState();
}

class _BusNotificationScreenState extends State<BusNotificationScreen> {
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getData(String collection) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection(collection).get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching $collection data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerRight,
          child: Column(
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
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.poppins(),
              tabs: const [
                Tab(text: "Notification"),
                Tab(text: "Complaint View"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildListView('feedback'),
                  buildListView('complaints'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListView(String collection) {
    return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
      future: getData(collection),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final dataList = snapshot.data!;
        return ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final data = dataList[index].data()!;
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: DEFAULT_BLUE_DARK,
                backgroundImage: AssetImage("assets/userdp.png"),
              ),
              title: Text(
                data['username'] ?? 'Anonymous',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              subtitle: collection == 'feedback'
                  ? buildFeedbackSubtitle(data)
                  : buildComplaintSubtitle(data),
            );
          },
        );
      },
    );
  }

  Widget buildFeedbackSubtitle(Map<String, dynamic> feedback) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(feedback['feedback'] ?? ''),
        ),
        const SizedBox(width: 20),
        RatingStars(
          starSize: 15,
          value: (feedback['rating'] ?? 0).toDouble(), // Ensure this is double
          starCount: 5, // Number of stars to show
          starOffColor: const Color.fromARGB(255, 243, 191, 34),
          valueLabelVisibility: false,
        ),
      ],
    );
  }

  Widget buildComplaintSubtitle(Map<String, dynamic> complaint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(complaint['complaint'] ?? ''),
        const SizedBox(height: 5),
        const Text(
          "Complaint Was registered",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
