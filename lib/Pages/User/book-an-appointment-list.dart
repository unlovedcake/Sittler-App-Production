
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/src/provider.dart';
import 'package:sittler_app/Controller-Provider/User-Controller/user-signup-signin.dart';
import 'package:sittler_app/Pages/User/book-a-sittler.dart';
import 'package:cherry_toast/cherry_toast.dart';

class BookAnAppointment extends StatefulWidget {
  @override
  _BookAnAppointmentState createState() => _BookAnAppointmentState();
}

class _BookAnAppointmentState extends State<BookAnAppointment> {
  Position? _currentUserPosition;
  double? distanceImMeter = 0.0;
  double defualtValue = 1.0;
  List listUsers = [];
  String? _currentAddress;

  List<int> res = [];
  List rateStar = [];
  String ratings = "0";
  int max_index = 0;
  int max_value = 0;

  Future getAllUser() async {
    try {
      final res = await FirebaseFirestore.instance
          .collection("table-sittler")
          .where("active", isEqualTo: true)
          .get();

      for (var doc in res.docs) {
        listUsers.add(doc.data());
      }



      getDis();

    } catch (e) {
      return null;
    }
  }

  Future getDis() async {
    try {
      _currentUserPosition =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      if (listUsers.isNotEmpty) {
        for (int i = 0; i < listUsers.length; i++) {
          double? storelat = listUsers[i]['position']['latitude'];
          double? storelng = listUsers[i]['position']['longitude'];

          distanceImMeter = Geolocator.distanceBetween(
            _currentUserPosition!.latitude,
            _currentUserPosition!.longitude,
            storelat!,
            storelng!,
          );
          double? distance = distanceImMeter?.round().toDouble();

          listUsers[i]['distance'] = (distance! / 1000).round().toDouble();

          _currentUserPosition =
              await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

          List<Placemark> placemarks = await placemarkFromCoordinates(
              listUsers[i]['position']['latitude'],
              listUsers[i]['position']['longitude']);

          Placemark place = placemarks[0];

          _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";

          listUsers[i]['address'] = _currentAddress;

          setState(() {});
        }
      }

      listUsers.sort((a, b) => a["distance"].compareTo(b["distance"]));
    } catch (e) {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();

    getAllUser();


  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: FutureBuilder(
        future: getDis(),
        builder: (context, projectSnap) {
          // if (projectSnap.connectionState == ConnectionState.waiting) {
          //   return Center(child: CircularProgressIndicator(color: Colors.black));
          // }

          if (listUsers.isEmpty) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xff004aa0),
                ),
                OutlinedButton(
                    onPressed: () {
                      CherryToast.warning(
                        title: const Text(''),
                        displayTitle: false,
                       
                      );
                    },
                    child: const Text("Click Refresh Page"))
              ],
            ));
          } else {
            return ListView.builder(
              itemCount: listUsers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      imageUrl: listUsers[index]['imageUrl'],
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                    //title: Text(listUsers[index]['fullName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listUsers[index]['fullName'],
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(listUsers[index]['address'] ?? "Pakistan"),
                        const SizedBox(
                          height: 4,
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          Expanded(
                            child: Text("${listUsers[index]['distance']}"
                                'KM Away'),
                          ),
                          RatingBarIndicator(
                            rating: 3,
                            //rating: 3,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookASittler()),
                      );

                      context
                          .read<SignUpSignInController>()
                          .setUserServiceEmail(listUsers[index]['email']);

                      print(listUsers[index]['email']);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
