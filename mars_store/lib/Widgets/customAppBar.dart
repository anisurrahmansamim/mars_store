import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.blue),
      centerTitle: true,
      title: Image.asset('images/logo.png',width: 150,fit: BoxFit.cover,),
      bottom: bottom,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => StoreHome()));
      }),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              IconButton(icon: Icon(Icons.shopping_cart_outlined,color: Colors.blue,), onPressed: (){
                Route route = MaterialPageRoute(builder: (_) => CartPage());
                Navigator.pushReplacement(context, route);
              }),
              Positioned(
                  right: 3.0,

                  child: Stack(
                    children: [
                      Icon(Icons.brightness_1,size: 20.0,color: Colors.red,),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 6.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context,counter,_){
                            return Text(counter.count.toString(),style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 12.0),);

                          },
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
