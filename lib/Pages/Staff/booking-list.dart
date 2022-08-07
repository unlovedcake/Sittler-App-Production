import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sittler_app/Model/book-model.dart';
import 'package:sittler_app/Model/sittler-model.dart';
import 'package:sittler_app/Route-Navigator/route-navigator.dart';

import 'chat-to-parent.dart';

class BookingList extends StatefulWidget {
  const BookingList({Key? key}) : super(key: key);

  @override
  _BookingListState createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  User? user = FirebaseAuth.instance.currentUser;
  SittlerModel loggedInUser = SittlerModel();

  void sendPushMessage(String token, String title, String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAK-9tvqM:APA91bFSuuKsJVoTuNC19D_Tg1QkmW2Cfbfop879_daYGyvQYOa3zWBP2qcQwRfUPf5UVsJ01-xc6ZTfnz5cBjrkRQRRUPRshiflERqjCdU5byGIoHma8XrVuO2HPEE4FHCWUyTW5D9X',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection("table-staff")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = SittlerModel.fromMap(value.data());

      print(loggedInUser.fullName);
    });

    return Scaffold(
      
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("table-book")
            .where('userStaff.uid', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  final userParent = snapshot.data!.docs[index];
                  final DocumentSnapshot bookingData = snapshot.data!.docs[index];

                  return Card(
                    elevation: 1,
                    child: ListTile(
                      leading: Image.network(
                        userParent.get('userModel.imageUrl'),
                      ),
                      title: Text(userParent.get('userModel.fullName')),
                      subtitle: Text(userParent.get('userModel.clientAddress')),
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            elevation: 10,
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  
                                  
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.green,
                                      child: MaterialButton(
                                          padding:
                                              const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                          minWidth: MediaQuery.of(context).size.width,
                                          onPressed: () async {
                                            sendPushMessage(
                                                userParent.get('userModel.token'),
                                                "${loggedInUser.fullName}",
                                                "accept your booking..");

                                            print("Accept");
                                          },
                                          child: const Text(
                                            "Accept",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xff004aa0),
                                      child: MaterialButton(
                                          padding:
                                              const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                          minWidth: MediaQuery.of(context).size.width,
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            RouteNavigator.gotoPage(
                                                context,
                                                ChatToParent(
                                                    parentInfo: BookModel.fromMap(
                                                        userParent.data())));
                                          },
                                          child: const Text(
                                            "Send Message",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.red,
                                      child: MaterialButton(
                                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                          minWidth: MediaQuery.of(context).size.width,
                                          onPressed: () async {},
                                          child: const Text(
                                            "Cancel Booking",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                  ),


                                ],
                              );
                            });
                      },
                    ),
                  );
                });
          } else {
            return const Center(child: Text("No Data"));
          }
        },
      ),
    );
  }
}
