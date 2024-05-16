import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/utils/style.dart';

class UserFareDetails extends StatelessWidget {
  const UserFareDetails({super.key});

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
      body: Column(
        children: [
          Text(
            "Fare Details",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          SizedBox(height: size.height * .02),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No fare details available.'));
                } else {
                  final fareData = snapshot.data!;
                  return DataTable(
                    dataTextStyle: TextStyle(color: Colors.black),
                    columnSpacing: 20,
                    columns: [
                      DataColumn(
                        label: Text(
                          "From",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "To",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Rs",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: fareData.map<DataRow>((doc) {
                      var data = doc.data() ?? {};
                      return DataRow(cells: [
                        DataCell(Text(data['from'] ?? 'N/A')),
                        DataCell(Text(data['to'] ?? 'N/A')),
                        DataCell(Text(data['rs'].toString())),
                      ]);
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('bus_fare').get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
