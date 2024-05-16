import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/utils/grid_view_home.dart';
import 'package:student_commute/view/user/searchresult.dart';
import 'package:student_commute/view/user/user_profile.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _searchBusSchedules() {
    final String from = _fromController.text.trim();
    final String to = _toController.text.trim();
    final String date = _dateController.text.trim();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(
          from: from,
          to: to,
          date: date,
        ),
      ),
    );
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
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserProfile(),
                ));
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/userdp.png'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _fromController,
                        decoration: InputDecoration(
                          hintText: 'From',
                          hintStyle: GoogleFonts.poppins(),
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.location),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Iconsax.arrow_up_3,
                              color: Colors.black,
                            ),
                            Icon(
                              Iconsax.arrow_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: _toController,
                        decoration: InputDecoration(
                          hintText: 'To',
                          hintStyle: GoogleFonts.poppins(),
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.location),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Date',
                          hintStyle: GoogleFonts.poppins(),
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          prefixIcon: IconButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            icon: const Icon(Iconsax.calendar_1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width,
                        child: ElevatedButton(
                          onPressed: _searchBusSchedules,
                          style: const ButtonStyle(
                            shape: MaterialStatePropertyAll<OutlinedBorder>(
                              ContinuousRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                            ),
                            minimumSize: MaterialStatePropertyAll<Size>(
                              Size.fromHeight(50),
                            ),
                            backgroundColor: MaterialStatePropertyAll(DEFAULT_BLUE_GREY),
                          ),
                          child: Text(
                            'Search',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CarouselSlider.builder(
              options: CarouselOptions(
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayCurve: Curves.fastOutSlowIn,
                viewportFraction: 1,
                autoPlay: true,
                aspectRatio: 20 / 9,

              ),
              itemCount: 10,
              itemBuilder: (
                context,
                itemIndex,
                pageViewIndex,
              ) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    height: 142,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: const Color.fromARGB(255, 30, 129, 221),
                       image: DecorationImage(
                        image: NetworkImage('https://t4.ftcdn.net/jpg/02/69/47/51/360_F_269475198_k41qahrZ1j4RK1sarncMiFHpcmE2qllQ.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Bus List'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                height: 220,
                width: size.width,
                child: const GridViewHome(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
