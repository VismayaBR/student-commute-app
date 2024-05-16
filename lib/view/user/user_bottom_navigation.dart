import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:student_commute/const.dart';
import 'package:student_commute/controller/user_controller.dart';

class UserBottomNavigation extends StatelessWidget {
  const UserBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Provider.of<UserController>(context);
    return Scaffold(
      body: bottomNavController.pages[bottomNavController.currentIndex],
      // bottomNavigationBar: AnimatedBottomNavigationBar(
      //   gapLocation: GapLocation.end,
      //   gapWidth: 10,
      //   backgroundColor: DEFAULT_BLUE_DARK,
      //   leftCornerRadius: 30,
      //   rightCornerRadius: 30,
      //   icons: const [
      //     Iconsax.home,
      //     Iconsax.bus,
      //     Iconsax.notification,
      //   ],
      //   activeIndex: bottomNavController.currentIndex,
      //   onTap: (p0) {
      //     bottomNavController.changeIndex(p0);
      //   },
      // ),
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
            BottomNavigationBarItem(icon: Icon(Iconsax.bus), label: 'Tickets'),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.notification), label: 'Notification'),
          ]),
    );
  }
}
