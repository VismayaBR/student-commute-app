import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/utils/style.dart';
import 'package:student_commute/utils/user_custom_appbar.dart';

class BusFareDetails extends StatefulWidget {
  const BusFareDetails({super.key});

  @override
  State<BusFareDetails> createState() => _BusFareDetailsState();
}

class _BusFareDetailsState extends State<BusFareDetails> {
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
      body: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No schedules available'));
          }

          final busSchedules = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Fare Details",
                  style: poppinStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                Center(
                  child: DataTable(
                    dataRowMinHeight: 25,
                    dataRowMaxHeight: 30,
                    border: TableBorder.all(),
                    columns: [
                      DataColumn(
                        label: Text("From",
                            style: poppinStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                      ),
                      DataColumn(
                        label: Text("To",
                            style: poppinStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                      ),
                      DataColumn(
                        label: Text(
                          "Rs",
                          style: poppinStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                    ],
                    rows: busSchedules.map((document) {
                      final schedule = document.data()!;
                      return DataRow(cells: [
                        DataCell(Text(schedule['from'] ?? 'N/A')),
                        DataCell(Text(schedule['to'] ?? 'N/A')),
                        DataCell(Text(schedule['rs']?.toString() ?? 'N/A')),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
