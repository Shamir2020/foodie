import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void ErrorToast(msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

void SuccessToast(msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.greenAccent,
      textColor: Colors.white,
      fontSize: 16.0
  );
}


Future<void> addToCart(Food) async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  final db = FirebaseFirestore.instance;
  var docId;
  bool isUpdate = false;
  await db.collection("cart").where('foodName', isEqualTo: Food['foodName']).get().then(
        (querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        var data = docSnapshot.data();
        if (data['uid'] == uid){
          isUpdate = true;
          docId = docSnapshot.id;
        }
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  if (isUpdate == false){
    await FirebaseFirestore.instance.collection('cart').doc().set({
      'foodName':Food['foodName'],
      'unitPrice':Food['price'],
      'totalPrice':Food['price'],
      'imageUrl':Food['imageUrl'],
      'quantity':Food['quantity'],
      'restaurantName':Food['restaurantName'],
      'uid':uid

    });
    SuccessToast('Item has been added to cart');
  }
  else{
    await FirebaseFirestore.instance.collection('cart').doc(docId).update({
      'foodName':Food['foodName'],
      'unitPrice':Food['price'],
      'totalPrice':int.parse(Food['price'])*Food['quantity'],
      'imageUrl':Food['imageUrl'],
      'quantity':Food['quantity'],
      'restaurantName':Food['restaurantName'],
      'uid':uid
    });
    SuccessToast('Item has been added to cart');
  }

}