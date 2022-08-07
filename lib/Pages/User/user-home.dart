import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:sittler_app/Pages/User/my-booking-list.dart';
import 'package:sittler_app/Pages/User/parent_settings.dart';
import 'package:sittler_app/Pages/User/user_chat.dart';
import 'package:sittler_app/Pages/User/user_dashboard.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'book-an-appointment-list.dart';

class UserHome extends StatefulWidget {
  const UserHome();
  

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
   int _currentIndex = 0;
  final int _counter = 0;

final screens = [
const user_dash(),
 BookAnAppointment(),
const MyBookingList(),
const user_chat(),
// const Center(child: Text('Chat', style: TextStyle(fontSize: 60),),),
const UserDrawer()
];



  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    //context.read<SignUpSignInController>().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
    DateTime backpress = DateTime.now();

    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(backpress);
        final cantExit = timegap >= const Duration(seconds: 2);
        backpress = DateTime.now();
        if (cantExit) {
          Fluttertoast.showToast(msg: 'Press Back button again to Exit');

          return false;
        } else {
          SystemNavigator.pop();

          return true;
        }
      },
      
      child: Scaffold(
        key: _key,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xff004aa0),
            elevation: 0,
          ),
        // drawer: const UserDrawer(),
        body:
        
        // StreamBuilder(
        //   stream: FirebaseFirestore.instance
        //       .collection("table-user-client")
        //       .where('email', isEqualTo: user!.email)
        //       .snapshots(),
        //   //stream: context.watch<SignUpSignInController>().getUserInfo(),
        //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
        //     final currentUser = snapshot.data;

        //     if (snapshot.hasData) {
        //       return SingleChildScrollView(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [

        //           ]
        //         ),
        //       );
        //     } else {
        //       return const Center(
        //           child: CircularProgressIndicator(
        //         color: Colors.black,
        //       ));
        //     }
        //   },
        // ),
        screens[_currentIndex],
        
    

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xff004aa0),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.apps),
            title: const Text('Home'),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
            
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.people),
            title: const Text('Hire'),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.list),
            title: const Text('Bookings'),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.message),
            title: const Text('Chat',),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Settings'),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      ),
    );
  }
}
