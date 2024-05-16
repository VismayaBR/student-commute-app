import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_commute/const.dart';

class BusSchedulesScreen extends StatefulWidget {
  const BusSchedulesScreen({super.key});

  @override
  State<BusSchedulesScreen> createState() => _BusSchedulesScreenState();
}

class _BusSchedulesScreenState extends State<BusSchedulesScreen> {
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('bus_schedules').get();
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
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => const UserBusesList(),
                // ));
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/Bus2.png'),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * .01,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Schedule",
              style: GoogleFonts.poppins(),
            ),
          ),
          SizedBox(
            height: size.height * .01,
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No schedules available.'));
                } else {
                  final scheduleData = snapshot.data!;
                  return ListView.builder(
                    itemCount: scheduleData.length,
                    itemBuilder: (context, index) {
                      var schedule = scheduleData[index].data();
                      print(schedule);
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: DEFAULT_BLUE_DARK,
                          child: Icon(
                            Iconsax.bus5,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          schedule!['bus'],
                          style: GoogleFonts.poppins(),
                        ),
                        subtitle: Text('${schedule['from']} - ${schedule['to']}'),
                        trailing: Text(
                          schedule!['time'],
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
    );
  }
}
