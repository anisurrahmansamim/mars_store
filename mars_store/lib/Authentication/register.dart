import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/login.dart';
import 'package:e_shop/Store/landinghome.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: _selectAndPickImage,
                child: Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.15,)
                  ),
                  child: CircleAvatar(
                    radius: size.width * 0.15,
                    backgroundColor: Colors.white70,
                    backgroundImage: _imageFile == null ? null : FileImage(_imageFile),
                    child: _imageFile == null
                        ? Icon(
                            Icons.add_photo_alternate,
                            size: size.width * 0.15,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameTextEditingController,
                      data: Icons.person,
                      hintText: "Name",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _emailTextEditingController,
                      data: Icons.email_outlined,
                      hintText: "Email",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _passwordTextEditingController,
                      data: Icons.lock_outline,
                      hintText: "Password",
                      isObsecure: true,
                    ),
                    CustomTextField(
                      controller: _cPasswordTextEditingController,
                      data: Icons.lock_outline,
                      hintText: "Confirm Password",
                      isObsecure: true,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      color: Colors.blue[300],
                        child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                        onPressed: (){
                        uploadAndSaveImage();
                        }
                    ),
                    SizedBox(
                      height: 38.0,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "Already have account?  ",style: TextStyle(color: Colors.black)),
                          TextSpan(
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
                              },
                              text: "Log In",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),

                        ]
                      ),

                    ),
                    SizedBox(
                      height: 38.0,
                    ),
                    // Container(
                    //   height: 4.0,
                    //   width: size.width * 0.8,
                    //   color: Colors.pink,
                    // ),
                    // SizedBox(
                    //   height: 15.0,
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _selectAndPickImage() async{
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
  Future<void>  uploadAndSaveImage () async{
    if(_imageFile == null ){
      showDialog(context: context, builder: (c){
        return ErrorAlertDialog(message: "Please Select an image file.",);
      });
    }
    else
      {
        _passwordTextEditingController.text == _cPasswordTextEditingController.text
            ? _emailTextEditingController.text.isNotEmpty
            && _passwordTextEditingController.text.isNotEmpty
            && _cPasswordTextEditingController.text.isNotEmpty
            && _nameTextEditingController.text.isNotEmpty
            ? uploadToStorage()

            : displayDialog("Please fill up the registration complete form...")
            : displayDialog("Password do not match.");
      }
  }

  displayDialog(String msg){
    showDialog(context: context, builder: (c){
      return ErrorAlertDialog(message: msg,);
    });
  }

  uploadToStorage()async{
    showDialog(context: context, builder: (c){
      return LoadingAlertDialog(message: "'Registering, Please wait.....'",);
    }
    );
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage){
      userImageUrl = urlImage;

      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
 void _registerUser()async{
    FirebaseUser firebaseUser;
    await _auth.createUserWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim(),
    ).then((auth){
      firebaseUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (c){
       return ErrorAlertDialog(message: error.message.toString(),);
      });
    });

    if(firebaseUser != null)
    {
      saveUserInfoToFireStore(firebaseUser).then((value){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (_) => LandingHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser fUser)async{
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList : ["garbageValue"]

    });

    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingController.text.trim());
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);

  }
}
