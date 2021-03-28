import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/more.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';
import 'package:carousel_pro/carousel_pro.dart';


double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   title: Image.asset('images/logo.png',width: 150,fit: BoxFit.cover,),
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Stack(
        //         children: [
        //           IconButton(icon: Icon(Icons.shopping_cart_outlined,color: Colors.blue,), onPressed: (){
        //             Route route = MaterialPageRoute(builder: (_) => CartPage());
        //             Navigator.pushReplacement(context, route);
        //           }),
        //           Positioned(
        //               right: 3.0,
        //
        //               child: Stack(
        //                 children: [
        //                   Icon(Icons.brightness_1,size: 20.0,color: Colors.red,),
        //                   Positioned(
        //                      top: 3.0,
        //                     bottom: 4.0,
        //                     left: 6.0,
        //                     child: Consumer<CartItemCounter>(
        //                       builder: (context,counter,_){
        //                         return Text(counter.count.toString(),style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 12.0),);
        //
        //                       },
        //                     ),
        //                   ),
        //                 ],
        //               )
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        //
        // ),
       body: CustomScrollView(
         slivers: [
           SliverAppBar(
             pinned: false,
             expandedHeight: 50.0,
             backgroundColor: Colors.white,
             elevation: 0,
             title: Image.asset('images/logo.png',width: 150,fit: BoxFit.cover,),
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

           ),
           SliverPersistentHeader(
             pinned: true,
               delegate: SearchBoxDelegate(),

           ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  child: Carousel(
                    dotSize: 4.0,
                    dotSpacing: 15.0,
                    dotColor: Colors.red,
                    indicatorBgPadding: 5.0,
                    dotBgColor: Colors.transparent,
                    dotVerticalPadding: 5.0,
                    dotPosition: DotPosition.bottomRight,
                    images: [
                      Image.network(
                        "https://pchouse.com.bd/image/cache/catalog/banner/slider/desktop/optimized/Optimized-multi-banner-760x470.png",
                        fit: BoxFit.cover,
                      ),
                      Image.network("https://pchouse.com.bd/image/cache/catalog/banner/slider/desktop/optimized/mi%20slider-760x470.jpg", fit: BoxFit.cover),
                      Image.network("https://pchouse.com.bd/image/cache/catalog/banner/slider/desktop/optimized/smartwatch-760x470.jpg", fit: BoxFit.cover),
                    ],
                  ),
                ),
              ),

            ),
           // Container(
           //   height: 50,
           //   width: width,
           //   color: Colors.red,
           // ),
           StreamBuilder<QuerySnapshot>(
             stream: Firestore.instance.collection("items").limit(15).orderBy("publishedDate",descending: true).snapshots(),
               builder: (context,dataSnapshot)
               {
                 return !dataSnapshot.hasData
                     ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                     : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                   staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                   itemBuilder: (context,index){
                      ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                      return sourceInfo( model, context);
                 },
                   itemCount: dataSnapshot.data.documents.length,
                 );
               }
           ),
         ],
       ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {

  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder: (_) => ProductPage(itemModel: model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.blue,
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: 190,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width: 140.0,height: 140.0,),
            SizedBox(
              width: 4.0,
            ),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(model.title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.0),),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(model.shortInfo, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.0),),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.lightBlueAccent,
                      ),
                      alignment: Alignment.topLeft,
                      width: 45.0,
                      height: 43.0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("50%",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0),),
                            Text("OFF",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 12.0),)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              Text("Original Price: ৳",style: TextStyle(fontSize: 14.0,color: Colors.blue,decoration: TextDecoration.lineThrough),),
                              Text((model.price + model.price).toString(),style: TextStyle(fontSize: 15.0,color: Colors.blue,decoration: TextDecoration.lineThrough),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Text("Original Price: ",style: TextStyle(fontSize: 14.0,color: Colors.blue),),
                              Text("৳",style: TextStyle(fontSize: 16.0,color: Colors.red),),
                              Text((model.price).toString(),style: TextStyle(fontSize: 15.0,color: Colors.blue),)
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Flexible(child: Container())

              ],
            ))
          ],
        ),
      ),
    ),
  );
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}



void checkItemInCart(String productID, BuildContext context)
{
}
