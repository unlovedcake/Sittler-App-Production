import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class user_dash extends StatefulWidget {
  const user_dash({ Key? key }) : super(key: key);

  @override
  State<user_dash> createState() => _user_dashState();
}

class _user_dashState extends State<user_dash> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: "Dashboard Content Here",
 style: TextStyle(fontSize: 30.0, color: Colors.black, fontWeight: FontWeight.bold),
              )
           
            )           
              
            
            
          ]
          ),
      ) 
    );
  }
}

