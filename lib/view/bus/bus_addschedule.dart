import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/utils/style.dart';

class BusAddScheduleScrren extends StatelessWidget {
  BusAddScheduleScrren({super.key});

  final TextEditingController regno = TextEditingController();
  final TextEditingController bus = TextEditingController();
  final TextEditingController from = TextEditingController();
  final TextEditingController to = TextEditingController();
  final TextEditingController time = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Add Schedule",
                    style: poppinStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                _buildTextField('Vehicle Number', regno),
                _buildTextField('Vehicle Name', bus),
                _buildTextField('From', from),
                _buildTextField('To', to),
                _buildTimeField(context, 'Time', time),
                SizedBox(
                  height: size.height * .025,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: size.width / 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addSchedule(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size.fromHeight(35),
                        backgroundColor: DEFAULT_BLUE_DARK,
                      ),
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "*required field";
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(BuildContext context, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(),
          ),
          TextFormField(
            readOnly: true,
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "*required field";
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onTap: () {
              _selectTime(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      time.text = picked.format(context);
    }
  }

  Future<void> addSchedule(BuildContext context) async {
    try {
      SharedPreferences spref = await SharedPreferences.getInstance();
      var id = spref.getString('user_id');

      if (id == null) {
        throw Exception("User ID not found in shared preferences");
      }

      await FirebaseFirestore.instance.collection('bus_schedules').add({
        'bus_id': id,
        'regno': regno.text,
        'bus': bus.text,
        'from': from.text,
        'to': to.text,
        'time': time.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Schedule added successfully!')),
      );
      Navigator.of(context).pop(); // Optionally, navigate back after adding
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add schedule: $e')),
      );
    }
  }
}
