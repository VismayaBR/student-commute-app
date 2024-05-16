import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_commute/model/user_model.dart';
import 'package:student_commute/view/user/user_bottom_navigation.dart';
import 'package:student_commute/view/user/user_home.dart';
import 'package:student_commute/view/user/user_notifications.dart';
import 'package:student_commute/view/user/user_tickets.dart';

class UserController extends ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  List carouselList = [
    'assets/Bus1.png',
    'assets/Bus2.png',
  ];

  List<Map<String, dynamic>> recentSearch = [
    {
      "route": 'Perinthalmanna - Malappuram',
      "time": '12pm - 1pm',
      "fare": "₹10",
      "regNo": "KL-11-AQ-9221"
    },
    {
      "route": 'Perinthalmanna - Manjeri',
      "time": '10am - 11am',
      "fare": "₹20",
      "regNo": "KL-11-AQ-9221"
    },
    {
      "route": 'Manjeri - Malappuram',
      "time": '3pm - 4pm',
      "fare": "₹30",
      "regNo": "KL-11-AQ-9221"
    },
    {
      "route": 'Perinthalmanna - Kozhikode',
      "time": '1pm - 2pm',
      "fare": "₹40",
      "regNo": "KL-11-AQ-9221"
    },
  ];

  List<Map<String, dynamic>> ticketList = [
    {
      "route": 'Perinthalmanna - Malappuram',
      "time": '12pm',
      "fare": "₹10",
      "regNo": "KL-11-AQ-9221"
    },
    {
      "route": 'Perinthalmanna - Manjeri',
      "time": '10am',
      "fare": "₹20",
      "regNo": "KL-11-AQ-9221"
    },
    {
      "route": 'Manjeri - Malappuram',
      "time": '3pm',
      "fare": "₹30",
      "regNo": "KL-11-AQ-9221"
    },
    {
      "route": 'Perinthalmanna - Kozhikode',
      "time": '1pm',
      "fare": "₹40",
      "regNo": "KL-11-AQ-9221"
    },
  ];

  List<Map<String, dynamic>> notificationList = [
    {
      "route": 'Perinthalmanna - Malappuram',
      "reachTime": '12pm',
      "regNo": "KL-11-AQ-9221",
      "status": "10 min late",
    },
    {
      "route": 'Perinthalmanna - Malappuram',
      "reachTime": '10am',
      "regNo": "KL-11-AQ-9221",
      "status": "on time",
    },
    {
      "route": 'Perinthalmanna - Malappuram',
      "reachTime": '11pm',
      "regNo": "KL-11-AQ-9221",
      "status": "5 min late",
    },
    {
      "route": 'Perinthalmanna - Malappuram',
      "reachTime": '3pm',
      "regNo": "KL-11-AQ-9221",
      "status": "15 min late",
    },
  ];

  List<Map<String, dynamic>> busesList = [
    {"name": 'Komban', "regNo": 'KL-11-AQ-9221'},
    {"name": 'KSRTC', "regNo": 'KL-15-A-2255'},
    {"name": 'Kallada Travels', "regNo": 'KL-10-AA-0021'},
    {"name": 'SRS Travels', "regNo": 'KL-07-BB-0007'},
    {"name": 'A1 Travels', "regNo": 'KL-02-AQ-1122'},
    {"name": 'KSRTC', "regNo": 'KL-15-AB-7896'},
  ];

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
    const UserHome(),
    const UserTickets(),
    const UserNotifications()
  ];

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  DateTime focusedDate = DateTime.now();

  void changeFocusedDate(DateTime selectedDate) {
    focusedDate = selectedDate;
    notifyListeners();
  }

  double ratingStar = 0;

  void changeRating(double rating) {
    ratingStar = rating;
    notifyListeners();
  }

  //////////////////////SIGNUP/////////////////////////
  final signUpKey = GlobalKey<FormState>();
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupuserNameController = TextEditingController();
  TextEditingController signupPhoneController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfrmPasswordController =
      TextEditingController();

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  Future<void> createAccount(
    String userid,
    String userName,
    String userEmail,
    int userPhone,
    context,
  ) async {
    try {
      _userModel = UserModel(
          userid: userid,
          userName: userName,
          userEmail: userEmail,
          userPhone: userPhone);

      await firebaseFirestore
          .collection('users')
          .doc(userid)
          .set(_userModel!.toMap());

      Navigator.of(context).pop();
    } catch (e) {
      CherryToast.error(
        title: Text(
          'Error!',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        description: Text(
          'Something went wrong, $e',
          style: GoogleFonts.poppins(),
        ),
      ).show(context);
    }
  }

  Future<void> signupUser(
    String userName,
    String userEmail,
    int userPhone,
    String userPassword,
    context,
  ) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);
      await userCredential.user!.sendEmailVerification();
      CherryToast.success(
        title: Text(
          'Success',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        description: Text(
          'Verification email send to $userEmail. Please verify email before login.',
          style: GoogleFonts.poppins(),
        ),
      ).show(context);
      print("///////////////////${userCredential.user!.uid}");
      await createAccount(
          userCredential.user!.uid, userName, userEmail, userPhone, context);
    } catch (e) {
      CherryToast.error(
        title: Text(
          'Error!!!',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        description: Text(
          'Something went wrong, $e',
          style: GoogleFonts.poppins(),
        ),
      ).show(context);
    }
  }

  ///////////////////////////LOGIN///////////////////////////
  ///
  final loginKey = GlobalKey<FormState>();
  TextEditingController userLoginEmail = TextEditingController();
  TextEditingController userLoginPassword = TextEditingController();

  Future<void> userLogin(
    String userName,
    String userPassword,
    context,
  ) async {
    try {
      UserCredential usercredential = await firebaseAuth
          .signInWithEmailAndPassword(email: userName, password: userPassword);

      if (usercredential.user!.emailVerified) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserBottomNavigation(),
            ),
            (route) => false);
      } else {
        CherryToast.warning(
          title: Text(
            'Email Verification!',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          description: Text(
            'Please verify your Email for login',
            style: GoogleFonts.poppins(),
          ),
        ).show(context);
      }
    } catch (e) {
      CherryToast.error(
        title: Text(
          'Error!!!',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        description: Text(
          'Something went wrong, $e',
          style: GoogleFonts.poppins(),
        ),
      ).show(context);
    }
  }

  Future fetchUserData(context) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        _userModel = UserModel(
          userid: snapshot['userid'],
          userName: snapshot['userName'],
          userEmail: snapshot['userEmail'],
          userPhone: snapshot['userPhone'],
          proPicURL: snapshot['proPicURL'],
        );
      });
    } catch (e) {
      print(e);
    }
  }
}
