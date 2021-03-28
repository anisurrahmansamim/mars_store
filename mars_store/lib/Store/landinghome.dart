import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/more.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class LandingHome extends StatefulWidget {
  @override
  _LandingHomeState createState() => _LandingHomeState();
}

class _LandingHomeState extends State<LandingHome> {
  final pages = [StoreHome(),MyOrders(),CartPage(),More()];
  var _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
          color: Colors.blue,
          backgroundColor: Colors.white,
          buttonBackgroundColor: Colors.blue,
          animationCurve: Curves.easeOutSine,
          height: MediaQuery.of(context).size.height/18,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index){
          setState(() {
            _page = index;

          });
          },
          items: [
            Icon(Icons.home_filled,color: Colors.white, ),
            Icon(Icons.card_travel,color: Colors.white,),
            Icon(Icons.shopping_cart_outlined,color: Colors.white,),
            Icon(Icons.widgets_rounded,color: Colors.white,),
          ]
      ),
      body: pages[_page],
    );
  }
}
