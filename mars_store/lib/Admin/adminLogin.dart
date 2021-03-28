import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mars Store"),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIDTextEditingController =
  TextEditingController();
  final TextEditingController _passwordTextEditingController =
  TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.height/1.9,
            width: size.width,
            alignment: Alignment.bottomCenter,
            child: Image.asset("images/admin.png"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Admin",style: TextStyle(color: Colors.black,fontSize: 28.0,fontWeight: FontWeight.bold),),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [

                CustomTextField(
                  controller: _adminIDTextEditingController,
                  data: Icons.person,
                  hintText: "ID",
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
                _adminIDTextEditingController.text.isNotEmpty && _passwordTextEditingController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(context: context, builder: (c){
                  return ErrorAlertDialog(message: "Please write ID and password",);
                });
              }
          ),
          SizedBox(
            height: 50.0,
          ),


          SizedBox(
            height: 20.0,
          ),
          FlatButton.icon(
              onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => AuthenticScreen())),
              icon: Icon(Icons.nature_people),
              label: Text("I'm not Admin",style: TextStyle(fontWeight: FontWeight.bold),)),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }
  loginAdmin(){
    Firestore.instance.collection("admins").getDocuments().then((snapshot){
      snapshot.documents.forEach((result) {
        if(result.data["id"] != _adminIDTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your ID is not correct.")));
        }
       else if(result.data["password"] != _passwordTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your Password is not correct.")));
        }
       else
         {
           Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Dear Admin,"+result.data["name"])));
           setState(() {
             _adminIDTextEditingController.text = "";
             _passwordTextEditingController.text = "";
           });
           Route route = MaterialPageRoute(builder: (_) => UploadPage());
           Navigator.pushReplacement(context, route);
         }
      });
    });
  }
}
