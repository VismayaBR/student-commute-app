import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';
import 'package:student_commute/view/user/user_bus_details_page.dart';

class UserBusesList extends StatefulWidget {
  const UserBusesList({super.key});

  @override
  State<UserBusesList> createState() => _UserBusesListState();
}

class _UserBusesListState extends State<UserBusesList> {
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('bus').get();
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
            return const Center(child: Text('No buses available'));
          }

          final busesList = snapshot.data!;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: size.width,
                height: size.height * 0.07,
                child: Center(
                  child: Text(
                    'Buses',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: busesList.length,
                  itemBuilder: (context, index) {
                    final bus = busesList[index].data();
                    print(busesList[index].id);
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserBusDetailsPage(
                            busName: bus!['bus'],
                            busId: busesList[index].id,
                            regNo: bus['reg_no'],
                          ),
                        ));
                      },
                      leading: const CircleAvatar(
                        backgroundColor: DEFAULT_BLUE_DARK,
                        child: Icon(
                          Iconsax.bus5,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        bus!['bus'] ?? 'N/A',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text("(${bus!['reg_no'] ?? 'N/A'})"),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
