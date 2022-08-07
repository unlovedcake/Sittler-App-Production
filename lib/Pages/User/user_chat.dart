import 'package:flutter/material.dart';

class user_chat extends StatefulWidget {
  const user_chat({ Key? key }) : super(key: key);

  @override
  State<user_chat> createState() => _user_chatState();
}

class _user_chatState extends State<user_chat> {
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
                text: "Chatting will be done here!",
 style: TextStyle(fontSize: 30.0, color: Colors.black, fontWeight: FontWeight.bold),
              )
           
            )           
              
            
            
          ]
          ),
      ) 
    );
  }
}