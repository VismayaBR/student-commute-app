import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:student_commute/view/bus/bus_home.dart';
import 'package:student_commute/view/bus/bus_notification.dart';
import 'package:student_commute/view/bus/bus_schedule.dart';

class BusController with ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  bool isConditionsVerified = false;

  void changeCondition(bool value) {
    if (value == false) {
      isConditionsVerified = false;
    } else {
      isConditionsVerified = true;
    }
    notifyListeners();
  }

  bool isObsecure = true;
  void changeObsecure() {
    isObsecure = !isObsecure;
    notifyListeners();
  }

  int currentIndex = 0;

  List<Widget> pages = [
    const BusHomeScreen(),
    const BusSchedulesScreen(),
    const BusNotificationScreen()
  ];
  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  List<Map<String, dynamic>> scheduleList = [
    {
      "route": 'Perinthalmanna - Malappuram',
      "time": '12pm',
    },
    {
      "route": 'Perinthalmanna - Manjeri',
      "time": '10am',
    },
    {
      "route": 'Manjeri - Malappuram',
      "time": '3pm',
    },
    {
      "route": 'Perinthalmanna - Kozhikode',
      "time": '1pm',
    },
  ];

  List<Map<String, dynamic>> notificationList = [
    {
      "name": 'Rohith C',
      "comment": 'Nice',
      "rating": 4,
    },
    {
      "name": 'Sanay UJ',
      "comment": 'Good',
      "rating": 3,
    },
    {
      "name": 'Akshay',
      "comment": 'Nice',
      "rating": 5,
    },
    {
      "name": 'Mohammed',
      "comment": 'Nice',
      "rating": 1,
    },
  ];
  List<Map<String, dynamic>> complaintList = [
    {
      "name": 'Rohith C',
      "complaint":
          "What should I do if a bus conductor in Kerala is not providing balance money?"
    },
    {
      "name": 'Sanay UJ',
      "complaint":
          "What should I do if a bus conductor in Kerala is not providing balance money?"
    },
    {
      "name": 'Akshay',
      "complaint":
          "What should I do if a bus conductor in Kerala is not providing balance money?"
    },
    {
      "name": 'Mohammed',
      "complaint":
          "What should I do if a bus conductor in Kerala is not providing balance money?"
    },
  ];

  TextEditingController scheduleVehiclenumberController = TextEditingController();
  TextEditingController scheduleVehicleNameController = TextEditingController();
  TextEditingController scheduleFromController = TextEditingController();
  TextEditingController scheduleToController = TextEditingController();
  TextEditingController scheduleTimeController = TextEditingController();

  //------------------------ S I G N - I N ----------------------
  TextEditingController loginMobileController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();

  //------------------------ S I G N - U P ----------------------
  final signUpKey = GlobalKey<FormState>();
  TextEditingController signupMobileNumberController = TextEditingController();
  TextEditingController signupOwnerNameController = TextEditingController();
  TextEditingController signupBusNameController = TextEditingController();
  TextEditingController signupRegistrationNumberController =
      TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfrmPasswordController =
      TextEditingController();
}
