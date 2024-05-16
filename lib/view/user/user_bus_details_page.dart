import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';
import 'package:student_commute/view/user/user_feedback.dart';

class UserBusDetailsPage extends StatefulWidget {
  final String busName;
  final String regNo;
  final String busId;

  const UserBusDetailsPage({
    required this.busName,
    required this.regNo,
    required this.busId,
    super.key,
  });

  @override
  State<UserBusDetailsPage> createState() => _UserBusDetailsPageState();
}

class _UserBusDetailsPageState extends State<UserBusDetailsPage> {
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('bus_schedules')
              .where('bus_id', isEqualTo: widget.busId)
              .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dateController = Provider.of<UserController>(context);

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

          final schedules = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.23,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/Bus3.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width / 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.busName,
                              style: GoogleFonts.poppins(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "(${widget.regNo})",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UserFeedBack(),
                        ));
                      },
                      icon: const Icon(Iconsax.card_edit),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.bus5),
                    ),
                  ],
                ),
                EasyInfiniteDateTimeLine(
                  firstDate: DateTime.now(),
                  focusDate: dateController.focusedDate,
                  lastDate: DateTime(2100),
                  onDateChange: (selectedDate) {
                    dateController.changeFocusedDate(selectedDate);
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index].data();
                      return Card(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('From: ${schedule!['from']}',
                                  style: GoogleFonts.poppins()),
                              Text('To: ${schedule['to']}',
                                  style: GoogleFonts.poppins()),
                              Text('Time: ${schedule['time']}',
                                  style: GoogleFonts.poppins()),
                            ],
                          ),
                        ),
                      );
                    },
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
