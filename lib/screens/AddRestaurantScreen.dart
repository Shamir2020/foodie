import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodie/utility/utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../style/styles.dart';

class AddRestaurant extends StatefulWidget {
  const AddRestaurant({Key? key}) : super(key: key);

  @override
  State<AddRestaurant> createState() => _AddRestaurantState();
}

class _AddRestaurantState extends State<AddRestaurant> {
  Map<String,String> FormValues = {'restaurantName':"",'minimumDeliveryFee':"",'serviceFee':"",'deliveryDuration':"",'imageUrl':''};
  bool photoMode = false;
  InputOnChange(MapKey,MapValue){
    setState(() {
      FormValues.update(MapKey, (value) => MapValue);
    });
  }
  NextUploadPhoto(){

    if (FormValues['restaurantName'] == ''){
      ErrorToast('Restaurant name not provided');
    }
    else if (FormValues['minimumDeliveryFee'] == ''){
      ErrorToast('Minimum Delivery Fee not provided');
    }
    else if (FormValues['serviceFee'] == ''){
      ErrorToast('Service Fee not provided');
    }
    else if (FormValues['deliveryDuration'] == ''){
      ErrorToast('Delivery Duration not provided');
    }
    else{
      setState(() {
        photoMode = true;
      });
    }
  }
  FormOnSubmit() async{
    if (FormValues['restaurantName'] == ''){
      ErrorToast('Restaurant name not provided');
    }
    else if (FormValues['minimumDeliveryFee'] == ''){
      ErrorToast('Minimum Delivery Fee not provided');
    }
    else if (FormValues['serviceFee'] == ''){
      ErrorToast('Service Fee not provided');
    }
    else if (FormValues['deliveryDuration'] == ''){
      ErrorToast('Delivery Duration not provided');
    }
    else{
      print('Inside the else blcok');
      await addRestaurant();
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      SuccessToast('Restaurant added successfully!!');
    }

  }
  Future<void> addRestaurant() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    print(uid);
    await FirebaseFirestore.instance.collection('restaurants').doc(uid).set({
      'restaurantName':FormValues['restaurantName'],
      'minimumDeliveryFee':FormValues['minimumDeliveryFee'],
      'serviceFee':FormValues['serviceFee'],
      'deliveryDuration':FormValues['deliveryDuration'],
      'imageUrl':FormValues['imageUrl']

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

        var snapshot = await FirebaseStorage.instance.ref().child('restaurantImages/${FormValues['restaurantName']}').putFile(file);
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
        title: Text('Add a Restaurant',style: TextHead1(colorWhite),),
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
              // if (photoMode)ElevatedButton(
              //     onPressed: (){
              //       FormOnSubmit();
              //     },
              //     style: ElevatedButton.styleFrom(
              //         fixedSize: Size(double.infinity, 45),
              //         backgroundColor: Color.fromRGBO(255, 0, 123, 1),
              //         foregroundColor: Colors.white
              //     ),
              //     child: Text('Submit',style: TextHead1(colorWhite),)),
              if (photoMode == false)Column(
                children: [
                  Text('Write the Restaurant information',style: TextHead4(colorBlack),),
                  SizedBox(height: 15.0,),
                  SizedBox(height: 15.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 45
                        ),
                        labelText: 'Restaurant Name',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.redAccent)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.greenAccent)
                        )
                    ),
                    onChanged: (value){
                      InputOnChange('restaurantName', value);
                    },
                  ),
                  SizedBox(height: 15.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 45
                        ),
                        labelText: 'Minimum Delivery Fee',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.redAccent)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.greenAccent)
                        )
                    ),
                    onChanged: (value){
                      InputOnChange('minimumDeliveryFee', value);
                    },
                  ),
                  SizedBox(height: 15.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 45
                        ),
                        labelText: 'Service Fee',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.redAccent)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.greenAccent)
                        )
                    ),
                    onChanged: (value){
                      InputOnChange('serviceFee', value);
                    },
                  ),
                  SizedBox(height: 15.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 45
                        ),
                        labelText: 'Delivery Duration (minute)',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.redAccent)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.greenAccent)
                        )
                    ),
                    onChanged: (value){
                      InputOnChange('deliveryDuration', value);
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
