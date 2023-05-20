import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodie/utility/utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../style/styles.dart';

class AddFood extends StatefulWidget {
  var RestaurantName;
  AddFood(this.RestaurantName,{Key? key}) : super(key: key);

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  Map<String,String> FormValues = {'foodName':"",'foodType':"",'foodDescription':"",'':"",'price':"",'imageUrl':''};
  bool photoMode = false;
  InputOnChange(MapKey,MapValue){
    setState(() {
      FormValues.update(MapKey, (value) => MapValue);
    });
  }
  NextUploadPhoto(){

    if (FormValues['foodName'] == ''){
      ErrorToast('Food name not provided');
    }
    else if (FormValues['foodDescription'] == ''){
      ErrorToast('Food Description not provided');
    }
    else if (FormValues['price'] == ''){
      ErrorToast('Price not provided');
    }
    else if (FormValues['foodType'] == ''){
      ErrorToast('Food Type not provided');
    }

    else{
      setState(() {
        photoMode = true;
      });
    }
  }
  FormOnSubmit() async{
    if (FormValues['foodName'] == ''){
      ErrorToast('Food name not provided');
    }
    else if (FormValues['foodDescription'] == ''){
      ErrorToast('Food Description not provided');
    }
    else if (FormValues['price'] == ''){
      ErrorToast('Price not provided');
    }
    else if (FormValues['imageUrl'] == ''){
      ErrorToast('Image is required!!');
    }
    else{
      print('Inside the else blcok');
      await addRestaurant();
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      SuccessToast('Food added successfully!!');
    }

  }
  Future<void> addRestaurant() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    print(uid);
    await FirebaseFirestore.instance.collection('food').doc().set({
      'foodName':FormValues['foodName'],
      'foodDescription':FormValues['foodDescription'],
      'price':FormValues['price'],
      'imageUrl':FormValues['imageUrl'],
      'foodtype':FormValues['foodType'],
      'restaurantName':widget.RestaurantName,
      'uid':uid
    });
  }
  UploadPhoto() async{
    // await Permission.photos.request();
    // var permissionStatus = await Permission.photos.status;

    // if (permissionStatus.isGranted)
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null){
      var file = File(image.path);

      var snapshot = await FirebaseStorage.instance.ref().child('foodImages/${FormValues['foodName']}').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        FormValues.update('imageUrl', (value) => downloadUrl);
      });
      FormOnSubmit();
    }
    else{
      ErrorToast('Image is not found!');
    }
  }




  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 0, 123, 1),
        foregroundColor: Colors.white,
        elevation: 1,
        title: Text('Add a Food to ${widget.RestaurantName}',style: TextHead4(colorWhite),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              SizedBox(height: height*0.17,),
              if (photoMode)ElevatedButton(
                  onPressed: () async{
                    await UploadPhoto();

                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.tealAccent
                  ),
                  child: Text('Upload a photo & submit',style: TextHead4(colorBlack),)),
              if (photoMode == false)Column(
                children: [
                  Text('Write the Food information',style: TextHead4(colorBlack),),
                  SizedBox(height: 15.0,),
                  SizedBox(height: 15.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 45
                        ),
                        labelText: 'Food Name',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.redAccent)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.greenAccent)
                        )
                    ),
                    onChanged: (value){
                      InputOnChange('foodName', value);
                    },
                  ),
                  SizedBox(height: 15.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 45
                        ),
                        labelText: 'Food Type',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.redAccent)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.greenAccent)
                        )
                    ),
                    onChanged: (value){
                      InputOnChange('foodType', value);
                    },
                  ),
                  SizedBox(height: 15.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 45
                        ),
                        labelText: 'Food Description',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.redAccent)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.greenAccent)
                        )
                    ),
                    onChanged: (value){
                      InputOnChange('foodDescription', value);
                    },
                  ),
                  SizedBox(height: 15.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 45
                        ),
                        labelText: 'Price',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.redAccent)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.greenAccent)
                        )
                    ),
                    onChanged: (value){
                      InputOnChange('price', value);
                    },
                  ),

                  SizedBox(height: 15.0,),
                  ElevatedButton(
                      onPressed: (){
                        NextUploadPhoto();
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(double.infinity, 45),
                          backgroundColor: Color.fromRGBO(255, 0, 123, 1),
                          foregroundColor: Colors.white
                      ),
                      child: Text('Next',style: TextHead1(colorWhite),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
