import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/more.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';


class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  @override
  Widget build(BuildContext context)
  {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: screenSize.width,
              color: Colors.white,
              child: Column(
                children: [
                  Center(
                    child: Image.network(widget.itemModel.thumbnailUrl,height: screenSize.height/2,width: screenSize.width,),
                  ),
                  Container(
                    color: Colors.green[300],
                    child: SizedBox(
                      height: 1.0,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              widget.itemModel.title,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.itemModel.longDescription,
                            style: largeTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                           "৳" + widget.itemModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),

                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: InkWell(
                      onTap: (){},
                      child: Container(
                        color: Colors.lightBlueAccent,
                        width: screenSize.width -40.0,
                        height: 50.0,
                        child: Center(
                          child: Text("Add to Cart",style: addToCart ,),
                        ),
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
const addToCart = TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
