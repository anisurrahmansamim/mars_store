import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/ItemQuantity.dart';
import 'package:e_shop/Store/landinghome.dart';
import 'package:e_shop/Widgets/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => CartItemCounter(),
          ),
          ChangeNotifierProvider(
              create: (_) => CartItemCounter(),
          ),
          ChangeNotifierProvider(
              create: (_) => AddressChanger(),
          ),
          ChangeNotifierProvider(
              create: (_) => TotalAmount(),
          ),
        ],
      child:  MaterialApp(
          title: 'Mars Store',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.blue,
          ),
          home: SplashScreen(),
        ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displaySplash();
  }

  displaySplash(){
    Timer(Duration(seconds: 3), ()async{
      if(await EcommerceApp.auth.currentUser() != null){
        Route route = MaterialPageRoute(builder: (_) => LandingHome());
        Navigator.pushReplacement(context, route);
      }
      else
        {
          Route route = MaterialPageRoute(builder: (_) => Onboarding());
          Navigator.pushReplacement(context, route);
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/welcome.png"),
              SizedBox(
                height: 20.0,
              ),
              Text("World's Larget & Number Online Shop",style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      )
    );
  }
}
