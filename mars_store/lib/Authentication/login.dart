import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Authentication/register.dart';
import 'package:e_shop/Store/landinghome.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
  TextEditingController();
  final TextEditingController _passwordTextEditingController =
  TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height/1.9,
              width: size.width,
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/login.png"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Login to your account",style: TextStyle(color: Colors.black),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [

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

                ],
              ),
            ),
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                color: Colors.blue[300],
                child: Text("Login",style: TextStyle(color: Colors.white),),
                onPressed: (){
                  _emailTextEditingController.text.isNotEmpty && _passwordTextEditingController.text.isNotEmpty
                      ? loginUser()
                      : showDialog(context: context, builder: (c){
                        return ErrorAlertDialog(message: "Please write email and password",);
                  });
                }
            ),
            SizedBox(
              height: 50.0,
            ),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(text: "Create an Account?  ",style: TextStyle(color: Colors.black)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => Register()));
                        },
                        text: "Sign Up",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),

                  ]
              ),

            ),
            SizedBox(
              height: size.height/13,
            ),
            Container(
              height: 4.0,
              width: size.width * 0.8,
              color: Colors.blue,
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton.icon(
                onLongPress: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => AdminSignInPage())),
                icon: Icon(Icons.nature_people),
                label: Text("I'm Admin",style: TextStyle(fontWeight: FontWeight.bold),)),
          ],
        ),
      )

    );

  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser()async{
    showDialog(context: context, builder: (c){
      return LoadingAlertDialog(message: "Authenticating, Please wait....",);
    });
    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim()
    ).then((authUser){
      firebaseUser = authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (c){
        return ErrorAlertDialog(message: error.message.toString(),);
      });
    });
    if(firebaseUser != null){
      readData(firebaseUser).then((s){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (_) => LandingHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }
  Future readData(FirebaseUser fUser)async{
    Firestore.instance.collection("users").document(fUser.uid).get().then(( dataSnapshop) async {
      await EcommerceApp.sharedPreferences.setString("uid", dataSnapshop.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, dataSnapshop.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, dataSnapshop.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapshop.data[EcommerceApp.userAvatarUrl]);
      List<String> cartList = dataSnapshop.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, cartList);

    });
  }
}
