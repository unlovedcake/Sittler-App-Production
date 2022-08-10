import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:sittler_app/Controller-Provider/User-Controller/user-signup-signin.dart';
import 'package:sittler_app/Widgets/sizebox.dart';
import 'package:sittler_app/Pages/Staff/sittler_settings.dart';

import 'booking-list.dart';

class StaffHome extends StatefulWidget {
  const StaffHome({Key? key}) : super(key: key);

  @override
  _StaffHomeState createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
     int _currentIndex = 0;
  final int _counter = 0;

final screens = [
const Center(child: Text('Home', style: TextStyle(fontSize: 60),),),
const BookingList(),
const Center(child: Text('Chat', style: TextStyle(fontSize: 60),),),
const staffsettings(),
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
            title: const Text(""),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xff004aa0),
            elevation: 0,

          //   actions: [
          //   Switch(
          //       value: isDark,
          //       onChanged: (newValue) {
          //         context.read<ThemeManager>().toggleTheme(newValue);
          //       })
          // ],

          actions: [
            ElevatedButton(onPressed: (){SignUpSignInController.logout(context);}, child: const Text("SIGN OUT",
                    style: TextStyle(
                        fontSize: 16, letterSpacing: 2.2, color: Colors.black)),)
          ],
            
          ),
        


          body: 
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("table-sittler")
              .where('email', isEqualTo: user!.email)
              .where('active', isEqualTo: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
            //final currentUser = snapshot.data?.docs;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.orange,
              ));
            }
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                        "The admin will confirm your request in order to activate your account.", textAlign: TextAlign.center,),
                  ));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    addVerticalSpace(10),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: const Text(
                        'Hi, Welcome to Baby Sittler App ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    // addVerticalSpace(50),
                    // ElevatedButtonStyle.elevatedButton("List of Sittlers", onPressed: () {
                    //   RouteNavigator.gotoPage(context, BookAnAppointment());
                    // }),
                  ],
                ),
              );
            }
          },
        ),

        // screens[_currentIndex],
    

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

