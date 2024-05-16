import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';
import 'package:student_commute/utils/style.dart';
import 'package:student_commute/view/user/user_buses_list.dart';

class UserTickets extends StatefulWidget {
  const UserTickets({super.key});

  @override
  State<UserTickets> createState() => _UserTicketsState();
}

class _UserTicketsState extends State<UserTickets> {
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
    final ticketController = Provider.of<UserController>(context);

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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserBusesList(),
                ));
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/Bus2.png'),
              ),
            ),
          ),
        ],
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
