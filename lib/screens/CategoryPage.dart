import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../style/styles.dart';
import 'models.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}


//Sorry Bhaia. I was sick for a few days and this is why I couldn't finish this project.
// I programmed this project in only 2 days.
// I could easily complete it if I weren't sick and could have few more days to work on it.
class _CategoryViewState extends State<CategoryView> {
  var Restaurants = [];
  Future<void> FetchRestaurants() async{
    final snapshot = await FirebaseFirestore.instance.collection('restaurants').where('').get();
    var restaurants = snapshot.docs.map((e) => Restaurant().fromSnapshot(e).toMap()).toList();

    setState(() {
      Restaurants = restaurants;
    });
    print(restaurants);

  }
  
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (BuildContext context,index){

    });
  }
}
