import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/bus_controller.dart';
import 'package:student_commute/controller/user_controller.dart';

class BusBottomNavigationBar extends StatelessWidget {
  const BusBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Provider.of<BusController>(context);

    return Scaffold(
      body: bottomNavController.pages[bottomNavController.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: DEFAULT_ORANGE,
          unselectedItemColor: Colors.grey,
          backgroundColor: DEFAULT_BLUE_DARK,
          onTap: (value) {
            bottomNavController.changeIndex(value);
          },
          currentIndex: bottomNavController.currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.bus), label: 'Schedules'),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.notification), label: 'Notification'),
          ]),
    );
  }
}
