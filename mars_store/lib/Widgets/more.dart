import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/UserProfile/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class More extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List titleName = ["My Order","My Cart","Search","Profile", " Address", "Logout"];
    List icons = [Icons.card_travel,Icons.shopping_cart,Icons.search,Icons.person, Icons.add_location, Icons.logout];
    List pages = [MyOrders(),CartPage(),SearchProduct(),UserProfile(), Address(), AuthenticScreen()];

  var  size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Expanded(
            flex: 1,
              child: Container(
                height: size.height,
                width: size.width,
                // color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      animationDuration: Duration(milliseconds: 600),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                      elevation: 8,
                      child: Container(
                        height: size.height/10,
                        width: size.width/5,

                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          backgroundImage: NetworkImage(
                            EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                      style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.white),
                    )
                  ],
                ),
              )
          ),
            Expanded(
              flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0,left: 12.0),
                  child: ListView.builder(
                    itemCount: titleName.length,
                      itemBuilder: (contex,index){
                        return ListTile(
                          leading: Icon(icons[index],color: Colors.black,),
                          title: Text(titleName[index],style: TextStyle(color: Colors.black,),),
                          onTap: (){
                            // Route route = MaterialPageRoute(builder: (_) => pages[index]());
                            // Navigator.pushReplacement(context, route);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => pages[index]));
                          },
                        );
                      }
                  ),
                ),
                ),
            )
          ],
        ),
      ),
    );
  }
}
