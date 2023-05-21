import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/profileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../style/styles.dart';
import 'models.dart';
import 'RestaurantScreen.dart';
class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {
  String usertype = '';
  var Restaurants = [];
  Future<void> FetchRestaurants() async{
    final snapshot = await FirebaseFirestore.instance.collection('restaurants').get();
    var restaurants = snapshot.docs.map((e) => Restaurant().fromSnapshot(e).toMap()).toList();

    setState(() {
      Restaurants = restaurants;
    });
    print(restaurants);

  }

  ReadUserType() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      usertype = (prefs.getString('usertype'))!;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    ReadUserType();
    FetchRestaurants();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(255, 0, 123, 1),
        elevation: 0,
        title: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
            }, icon: Icon(Icons.person)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Foodie',style: TextHead4(colorWhite),),
                Text('Buy Food | Eat Healthy',style: TextHead4(colorWhite),)
              ],
            )
          ],
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, '/cart');
          }, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 7.0,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryCard('images/pizza.png','Pizza'),
                  CategoryCard('images/burger.png','Burger'),
                  CategoryCard('images/chicken.png','Chicken'),
                  CategoryCard('images/pasta.png','Pasta'),
                  CategoryCard('images/rice.png','Rice Dish'),
                  CategoryCard('images/shawarma.png','Shawarma'),

                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryCard('images/biryani.png','Biriyani'),
                  CategoryCard('images/cafe.png','Cafe'),
                  CategoryCard('images/dessert.png','Dessert'),
                  CategoryCard('images/kebab.png','Kebab'),
                  CategoryCard('images/snacks.png','Snacks'),
                  CategoryCard('images/soup.png','Soup'),

                ],
              ),
            ),

            CarouselSlider(items: [
              CarouselSliderContainer('images/sliderimages1.jpg'),
              CarouselSliderContainer('images/sliderimages2.jpg'),
              CarouselSliderContainer('images/sliderimages3.jpg'),
              CarouselSliderContainer('images/sliderimages4.jpg'),
              CarouselSliderContainer('images/sliderimages5.jpg'),
              CarouselSliderContainer('images/sliderimages6.jpg'),

            ], options: CarouselOptions(
              autoPlayInterval: Duration(seconds: 2),
              height: height*.29,
              autoPlay: true,
              viewportFraction: 1,
            )
            ),
            SizedBox(height: 10.0,),
            Center(child: Text('Top Rated Restaurants',style: TextHead1(colorBlack),),),
            SizedBox(height: 5,),
            // TRestaurants(height, width, 'Sultan Dines', 'italian, Dessert, Biriyani', '1km away - 30Tk Delivery Fee'),
            // TRestaurants(height, width, 'Sultan Dines', 'italian, Dessert, Biriyani', '1km away - 30Tk Delivery Fee'),
            // TRestaurants(height, width, 'Sultan Dines', 'italian, Dessert, Biriyani', '1km away - 30Tk Delivery Fee'),
            // TRestaurants(height, width, 'Sultan Dines', 'italian, Dessert, Biriyani', '1km away - 30Tk Delivery Fee'),
            ListView.builder(shrinkWrap:true,physics:NeverScrollableScrollPhysics(),itemCount:Restaurants.length,itemBuilder: (BuildContext context,int index){
              return TRestaurants(context, height, width, Restaurants[index]);
            })

          ],
          
        ),
      )
    );
  }
}

Padding CategoryCard(imageUrl,label){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: (){},
      child: Material(
        color: Color.fromRGBO(255, 0, 123, 1),
        borderRadius: BorderRadius.circular(5),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 70,
            height: 60,
            child: Column(
              children: [
                Image.asset(imageUrl,height: 32,),
                SizedBox(height: 10.0,),
                Text(label,style: SmallText(colorWhite),)
              ],
            ),
          ),
        ),
      ),
    )
  );
}


Container CarouselSliderContainer(imageUrl){
  return Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover
        )
    ),
  );
}

Center TRestaurants(context,height,width,Restaurant){
  return Center(
    child: InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RestaurantPage(Restaurant)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        width: width*0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Material(borderRadius:BorderRadius.circular(5),elevation: 2,child: Image.network(fit: BoxFit.fill,'${Restaurant['imageUrl']}',height: height*.27,width: width*0.9,),),),
            SizedBox(height: 8,),
            Text(Restaurant['restaurantName'],style: TextHead4(colorBlack),),
            Text('Food Menues',style: SmallText(colorBlack),),
            Text("Minimum Delivery Fee - ${Restaurant['minimumDeliveryFee']} Tk",style: SmallText(colorBlack),)
          ],
        ),
      ),
    )
  );
}