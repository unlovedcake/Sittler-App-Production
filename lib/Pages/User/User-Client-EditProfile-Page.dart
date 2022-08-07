import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:path/path.dart' as path;
import 'package:sittler_app/Controller-Provider/User-Controller/user-signup-signin.dart';
import 'package:sittler_app/Model/user-model.dart';

class UserClientEditProfilePage extends StatefulWidget {
  const UserClientEditProfilePage({Key? key}) : super(key: key);

  @override
  _UserClientEditProfilePageState createState() => _UserClientEditProfilePageState();
}

class _UserClientEditProfilePageState extends State<UserClientEditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameText = TextEditingController();
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _addressText = TextEditingController();
  final TextEditingController _contactText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();
  final TextEditingController _confirmPasswordText = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  FirebaseStorage storage = FirebaseStorage.instance;
  File? imageFile;
  String? fileName = "image.jpg";
  String? imageUrl;

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select a Photo From'),
            // content: TextField(
            //   controller: _textFieldController,
            //   textInputAction: TextInputAction.go,
            //   keyboardType: TextInputType.numberWithOptions(),
            //   decoration: InputDecoration(hintText: "Select a Photo From"),
            // ),
            actions: <Widget>[
              OutlinedButton(
                child: const Text('Gallery'),
                onPressed: () {
                  _upload('Gallery');
                  Navigator.pop(context);
                },
              ),
              OutlinedButton(
                child: const Text('Camera'),
                onPressed: () {
                  _upload('camera');
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    PickedFile? pickedImage;

    try {
      pickedImage = await picker.getImage(
          source: inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 1920);

      setState(() {
        fileName = path.basename(pickedImage!.path);

        imageFile = File(pickedImage.path);
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff004aa0)),
        centerTitle: true,
        title: const Text("Edit Profile", style: TextStyle(color: Color(0xff004aa0))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder(
          //stream: context.watch<ControllerClientProvider>().editUserClientDetails(),
          stream: FirebaseFirestore.instance
              .collection("table-user-client")
              .where('email', isEqualTo: user!.email)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
            final currentUser = snapshot.data?.docs;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data?.docs == 0) {
              return const Text("No Data Found");
            }
            return SingleChildScrollView(
              reverse: true,
                child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 2,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Stack(
                            children: <Widget>[
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: imageFile != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(75.0),
                                        child: Image.file(
                                          imageFile!,
                                          fit: BoxFit.cover,
                                          height: 200,
                                        ),
                                      )
                                    : Hero(
                                        tag: 'profileImage',
                                        child: CachedNetworkImage(
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          imageUrl: currentUser![0]['imageUrl'],
                                          imageBuilder: (context, imageProvider) =>
                                              Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(Radius.circular(80)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          progressIndicatorBuilder:
                                              (context, url, downloadProgress) =>
                                                  CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                            color: const Color(0xff004aa0),
                                          ),
                                          errorWidget: (context, url, error) => const Icon(
                                            Icons.error,
                                            size: 100,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Transform.scale(
                                  scale: 1.7,
                                  child: IconButton(
                                      color: const Color(0xff004aa0),
                                      onPressed: () {
                                        _displayDialog(context);
                                        //_upload("Gallery");
                                      },
                                      icon: const Icon(
                                        Icons.add_box_rounded,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameText..text = currentUser![0]['fullName'],
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          cursorColor: const Color(0xff004aa0),
                          //initialValue: "Okey",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Name is required ");
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color(0xff004aa0),
                            ),
                            hintText: "Name",
                            suffixIcon: const Icon(Icons.done),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff004aa0)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: _addressText..text = currentUser[0]['address'],
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.next,
                          cursorColor: const Color(0xff004aa0),
                          //initialValue: currentUser[0]['fullName'],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Address is required");
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.add_location,
                              color: Color(0xff004aa0),
                            ),
                            hintText: "Address",
                            suffixIcon: const Icon(Icons.done),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff004aa0)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: _contactText
                            ..text = currentUser[0]['contactNumber'],
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          cursorColor: const Color(0xff004aa0),
                          //initialValue: currentUser[0]['fullName'],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Contact is required");
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Color(0xff004aa0),
                            ),
                            hintText: "Contact Number",
                            suffixIcon: const Icon(Icons.done),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff004aa0)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: const Color(0xff004aa0),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: const Offset(2, 2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]),
                  child: TextButton(
                    child: const Text(
                      'Save Changes',
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xff004aa0),
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        UserModel userModel = UserModel();
                        userModel.fullName = _nameText.text;
                        userModel.contactNumber = _contactText.text;
                        userModel.address = _addressText.text;

                        if (fileName == "image.jpg") {
                          imageUrl = currentUser[0]['imageUrl'];
                        } else {
                          Reference ref = storage.ref().child(fileName!);

                          UploadTask? uploadTask = ref.putFile(imageFile!);

                          await uploadTask.whenComplete(() async {
                            imageUrl = await ref.getDownloadURL();
                          });
                        }

                        context.read<SignUpSignInController>().editProfile(
                            currentUser[0]['uid'], imageUrl, userModel, context);

                        // try {
                        //   if (fileName == "image.jpg") {
                        //     imageUrl = currentUser[0]['imageUrl'];
                        //     print("defualt image");
                        //     print("${imageUrl}" + "OKEOEKE");
                        //     print("${currentUser[0]['imageUrl']}" + "OKEOEKE");
                        //   } else {
                        //     Reference ref = storage.ref().child(fileName!);
                        //
                        //     UploadTask? uploadTask = ref.putFile(imageFile!);
                        //
                        //     await uploadTask.whenComplete(() async {
                        //       imageUrl = await ref.getDownloadURL();
                        //     });
                        //   }
                        //
                        //
                        //
                        //   await FirebaseFirestore.instance
                        //       .collection('table-user-client')
                        //       .doc(currentUser[0]['uid'])
                        //       .update({
                        //     "fullName": userModel.fullName,
                        //     "address": userModel.address,
                        //     "contactNumber": userModel.contactNumber,
                        //     "imageUrl":
                        //         imageUrl == null ? currentUser[0]['imageUrl'] : imageUrl,
                        //   }).then((_) async {
                        //     //This function will update the table book
                        //     // with field imageURL to User Client
                        //     await FirebaseFirestore.instance
                        //         .collection("table-book")
                        //         .where("userModel.uid", isEqualTo: currentUser[0]['uid'])
                        //         .get()
                        //         .then((result) {
                        //       result.docs.forEach((result) async {
                        //         print(result.id);
                        //         // final userCredential =
                        //         //     await FirebaseAuth.instance.currentUser;
                        //         // if (userCredential!.email != null) {
                        //         //   userCredential.updateEmail(userModel.email!);
                        //         // }
                        //
                        //         await FirebaseFirestore.instance
                        //             .collection('table-book')
                        //             .doc(result.id)
                        //             .update({
                        //           "userModel.imageUrl": imageUrl == null
                        //               ? currentUser[0]['imageUrl']
                        //               : imageUrl
                        //         }).then((_) async {
                        //           //Fluttertoast.showToast(msg: "Image Save");
                        //         });
                        //       });
                        //     });
                        //     print("success!");
                        //     CherryToast.success(
                        //       title: 'Geek Doctor',
                        //       displayTitle: true,
                        //       autoDismiss: true,
                        //       description: 'Sucessfully Save Changes !!!',
                        //       animationType: ANIMATION_TYPE.fromTop,
                        //       actionStyle: TextStyle(color: Colors.green),
                        //       animationDuration: Duration(milliseconds: 1000),
                        //       action: '',
                        //       actionHandler: () {},
                        //     ).show(context);
                        //     //Fluttertoast.showToast(msg: "Sucessfully Save Changes");
                        //   });
                        // } on FirebaseException catch (error) {
                        //   print(error);
                        // }
                      }
                    },
                  ),
                )
              ],
            ));
          }),
    );
  }
}