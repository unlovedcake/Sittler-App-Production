import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sittler_app/Pages/Onboarding-Screen/onboarding.dart';



class splash extends StatelessWidget {
  const splash({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Container(
              
              child: const Image(image: AssetImage("images/start2.png"), width: 350,), 
             
            ),

            const SizedBox(height: 20),

            const Text('Your account verification is pending', 
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center,),

            const SizedBox(height: 20),
          Column(
            children: const [
              Padding(padding: EdgeInsets.all(16.0),
              child: Text('We need to do a quick manual review on some of your detials and we might ask for more verifications, which could take up to 2 business days.', 
            style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center),)
          
            ],
          ),
        

            const SizedBox(height: 30),
      
            ElevatedButton(
            
            style: ElevatedButton.styleFrom(
              primary: const Color(0xff004aa0),
              onPrimary: Colors.white,
              shadowColor: const Color.fromARGB(255, 53, 143, 247),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minimumSize: const Size(200, 40),
              maximumSize: const Size(200, 40) //////// HERE
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Onboarding()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [ 
                Icon(FontAwesomeIcons.arrowLeft),
                Text(' Go Back ', style: TextStyle(color: Colors.white, fontSize: 20)),
              
            ]

            ),
            
          ),
            
          ],
        ),
      ),

    );
  }
}