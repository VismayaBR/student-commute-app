import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResultScreen extends StatelessWidget {
  final String from;
  final String to;
  final String date;

  const SearchResultScreen({
    Key? key,
    required this.from,
    required this.to,
    required this.date,
  }) : super(key: key);

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getData() async {
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('bus_schedules');
      if (from.isNotEmpty) {
        query = query.where('from', isEqualTo: from);
      }
      if (to.isNotEmpty) {
        query = query.where('to', isEqualTo: to);
      }
     

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Results',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No schedules available'));
          }

          final busSchedules = snapshot.data!;
          return Container(
            margin: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              itemCount: busSchedules.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final busSchedule = busSchedules[index].data();
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${busSchedule!['bus']}',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'From: ${busSchedule['from']}',
                          style: GoogleFonts.poppins(),
                        ),
                        Text(
                          'To: ${busSchedule['to']}',
                          style: GoogleFonts.poppins(),
                        ),
                        Text(
                          'Time: ${busSchedule['time']}',
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
