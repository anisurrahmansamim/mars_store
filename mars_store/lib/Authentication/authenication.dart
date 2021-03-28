import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to Mars Store',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Gotu',

                              ),
                            ),
                            Text(
                              'Update Your Life',
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ],
                        ))),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "images/onbording2.jpg",
                      fit: BoxFit.cover,
                    )),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 5,
                            child: GestureDetector(
                              child: Container(
                                  height: MediaQuery.of(context).size.height / 15,
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.blueAccent,
                                        Colors.blue[100]
                                      ]),
                                      borderRadius: BorderRadius.circular(10.0)),
                                  child: Center(
                                    child: Text(
                                      'Log In',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 20,
                          ),
                          GestureDetector(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Register()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
