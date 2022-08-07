import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:sittler_app/Controller-Provider/User-Controller/user-signup-signin.dart';
import 'package:sittler_app/Pages/Staff/sittler-signup.dart';
import 'package:sittler_app/Routes/routes.dart';
import 'package:sittler_app/Widgets/sizebox.dart';
import 'package:sittler_app/Widgets/textformfied.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StaffSignIn extends StatefulWidget {
  const StaffSignIn({Key? key}) : super(key: key);

  @override
  _StaffSignInState createState() => _StaffSignInState();
}

class _StaffSignInState extends State<StaffSignIn> {
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xff004aa0),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 2,
                    child: Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          
                            image: AssetImage("images/SITTLER1.png"),
                            fit: BoxFit.contain),
                        // boxShadow: <BoxShadow>[
                        //   BoxShadow(
                        //       color: Colors.black54,
                        //       blurRadius: 15.0,
                        //       offset: Offset(0.0, 0.75))
                        // ],
                        //color: Colors.white60,
                      ),
                    ),
                  ),
                  addVerticalSpace(20),
                  TextFormFields.textFormFields("Email", "Email", _emailText,
                      widget: null,
                      sufixIcon: null,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next, validator: (value) {
                    if (value!.isEmpty) {
                      return ("Email is required");
                    } else if (!value!.contains("@")) {
                      return ("Invalid Email Format");
                    }
                    return null;
                  }),
                  addVerticalSpace(20),
                  TextFormFields.textFormFields("Password", "Password", _passwordText,
                      widget: null,
                      sufixIcon: IconButton(
                        icon: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xff004aa0),
                        ),
                        onPressed: () {
                          // This is the trick

                          _isHidden = !_isHidden;

                          (context as Element).markNeedsBuild();
                        },
                      ),
                      obscureText: _isHidden,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done, validator: (value) {
                    if (value!.isEmpty) {
                      return ("Password is required ");
                    }
                    return null;
                  }),
                  addVerticalSpace(20),
                  
                  // ElevatedButtonStyle.elevatedButton("Login", 
                  
                  // onPressed: () {
                  //   if (_formKey.currentState!.validate()) {
                  //     context
                  //         .read<SignUpSignInController>()
                  //         .signIn(_emailText.text, _passwordText.text, context);
                  //   }
                  // }),

                  ElevatedButton(
            
            style: ElevatedButton.styleFrom(
              primary: const Color(0xff004aa0),
              onPrimary: Colors.white,
              shadowColor: const Color.fromARGB(255, 253, 152, 143),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minimumSize: const Size(150, 50),
              maximumSize: const Size(150, 50) //////// HERE
            ),
            onPressed: () {if (_formKey.currentState!.validate()) {
                      context
                          .read<SignUpSignInController>()
                          .signIn(_emailText.text, _passwordText.text, context);
                    }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: const [ 
                SizedBox(width: 10,),
                Text('Login ', style: TextStyle(color: Colors.white, fontSize: 14)),
              
            ]

            ),
            
          ),

                  // ElevatedButton(
                  //     child: Text("Login "),
                  //     onPressed: () {
                  //       // Navigator.pushNamed(context, '/user-client-login-page');
                  //     }),
                  addVerticalSpace(20),

                const Text('Or connect using', style: TextStyle(fontSize: 14, color: Colors.grey),),
                addVerticalSpace(20),
                // ElevatedButton(
            
            // style: ElevatedButton.styleFrom(
            //   primary: Color(0xFFF34334),
            //   onPrimary: Colors.white,
            //   shadowColor: Color.fromARGB(255, 253, 152, 143),
            //   elevation: 3,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20.0)),
            //   minimumSize: Size(150, 50),
            //   maximumSize: Size(150, 50) //////// HERE
            // ),
            // onPressed: () {
            //   _googleSignIn.signIn().then(
            //               (value) => Navigator.of(context).pushReplacement(
            //                 MaterialPageRoute(
            //                   builder: (context)=>const UserHome()
            //                   ),
            //                   )
            //             );
              
            // },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
              
          //     children: [ 
          //       Icon(FontAwesomeIcons.google),
          //       SizedBox(width: 10,),
          //       Text('Google ', style: TextStyle(color: Colors.white, fontSize: 14)),
              
          //   ]

          //   ),
            
          // ),
                addVerticalSpace(20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        NavigateRoute.gotoPage(context, const StaffSignUp());
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    )
                  ]),
                  addVerticalSpace(20),

                  
                ],
              ),
            ),
          )
          
          ),
    );
  }
}
