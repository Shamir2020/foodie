import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Restaurant{
  var restaurantName;
  var deliveryDuration;
  var minimumDeliveryFee;
  var serviceFee;
  var imageUrl;

  Restaurant({this.restaurantName,this.deliveryDuration,this.minimumDeliveryFee,this.serviceFee,this.imageUrl});

  toMap(){
    return {'restaurantName':restaurantName,'deliveryDuration':deliveryDuration,'minimumDeliveryFee':minimumDeliveryFee,'serviceFee':serviceFee,'imageUrl':imageUrl};
  }

  fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document) {
    final data = document.data()!;

    return Restaurant(
      restaurantName: data['restaurantName'],
      deliveryDuration: data['deliveryDuration'],
      minimumDeliveryFee: data['minimumDeliveryFee'],
      serviceFee: data['serviceFee'],
      imageUrl: data['imageUrl']
    );
  }
}