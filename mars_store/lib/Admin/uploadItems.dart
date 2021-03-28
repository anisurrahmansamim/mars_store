import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file ;
  TextEditingController _descriptiontextEditingController = TextEditingController();
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _shortinfoEditingController = TextEditingController();
  String productID = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen(): displayadminUploadFormScreen();
  }
  displayAdminHomeScreen(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Mars Store"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.border_color), onPressed: (){
          Route route = MaterialPageRoute(builder: (_) => AdminShiftOrders());
          Navigator.pushReplacement(context, route);
        }),
        actions: [
          FlatButton(onPressed: (){
            Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
            Navigator.pushReplacement(context, route);
          }, child: Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),))
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }
  getAdminHomeScreenBody(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shop_two,size: 200.0,),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0),
              ),
                child: Text("Add New Items",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                color: Colors.blue,
                onPressed: () => takeImage(context),
                ),
          )
        ],
      ),
    );
  }
  takeImage(mContext){
    return showDialog(
        context: mContext,
        builder: (con){
          return SimpleDialog(
            title: Text("Item Image",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
            children: [
              SimpleDialogOption(
                child: Text("Capture with Camera",style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Select From Gallery",style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: pickPhotoFromGallery,
              ),

              SimpleDialogOption(
                child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
  capturePhotoWithCamera()async{
    Navigator.pop(context);
    File ImageFile = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      file = ImageFile;
    });
  }

  pickPhotoFromGallery()async{
    Navigator.pop(context);
    File ImageFile = await ImagePicker.pickImage(source: ImageSource.gallery );
    setState(() {
      file = ImageFile;
    });
  }
  displayadminUploadFormScreen(){
    return Scaffold(
      appBar:  AppBar(
        title: Text("New Product"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: (){
          Route route = MaterialPageRoute(builder: (_) => clearformInfo());
          Navigator.pushReplacement(context, route);
        }),
        actions: [
          FlatButton(onPressed: (){
            uploading ? null : uploadImageAndSaveItemInfo();
            // Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
            // Navigator.pushReplacement(context, route);
          }, child: Text("Add",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),))
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(''),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                  aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: FileImage(file),fit: BoxFit.contain)
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),

          ListTile(
            leading: Icon(Icons.title),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: _titletextEditingController,
                decoration: InputDecoration(
                    hintText: "Title",
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: _shortinfoEditingController,
                decoration: InputDecoration(
                    hintText: "Short Info",
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: _descriptiontextEditingController,
                decoration: InputDecoration(
                    hintText: "Description",
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: _pricetextEditingController,
                decoration: InputDecoration(
                    hintText: "Price",
                    border: InputBorder.none
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),


        ],
      ),
    );
  }
  clearformInfo(){
  setState(() {
    file = null;
    _descriptiontextEditingController.clear();
    _pricetextEditingController.clear();
    _shortinfoEditingController.clear();
    _titletextEditingController.clear();
  });
  }
  uploadImageAndSaveItemInfo()async{
    setState(() {
      uploading = true;
    });
   String imageDownloadUrl = await uploadItemImage(file);

   saveItemInfo(imageDownloadUrl);
  }
 Future<String> uploadItemImage(mFileImage) async
 {
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask = storageReference.child("product_$productID.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String dounloadUrl = await taskSnapshot.ref.getDownloadURL();
    return dounloadUrl;
  }
  saveItemInfo(String downloadUrl){
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productID).setData({
      "shortInfo" : _shortinfoEditingController.text.trim(),
      "longDescription" : _descriptiontextEditingController.text.trim(),
      "price" : int.parse(_pricetextEditingController.text),
      "publishedDate" : DateTime.now(),
      "status" : "available",
      "thumbnailUrl" : downloadUrl,
      "title" : _titletextEditingController.text.trim(),
    });

    setState(() {
      file = null;
      uploading = false;
      productID = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptiontextEditingController.clear();
      _titletextEditingController.clear();
      _shortinfoEditingController.clear();
      _pricetextEditingController.clear();
    });
  }
}
