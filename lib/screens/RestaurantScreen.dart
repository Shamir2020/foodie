import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../style/styles.dart';
import 'FoodScreen.dart';
class RestaurantPage extends StatefulWidget {
  Map Restaurant;
  RestaurantPage(this.Restaurant,{Key? key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  var db = FirebaseFirestore.instance;
  var FoodLists = [];
  Future<void> FetchFoodData() async{
    await db.collection("food").where('restaurantName', isEqualTo:widget.Restaurant['restaurantName']).get().then(
          (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          setState(() {
            FoodLists.add(docSnapshot.data());
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    FetchFoodData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(fit: BoxFit.fill,'${widget.Restaurant['imageUrl']}',height: height*.27,width: width,),
              ),
              SizedBox(height: height*0.03,),
              Padding(
                padding: EdgeInsets.all(width*0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.Restaurant['restaurantName'],style: TextHead1(colorBlack),),
                    Text('Minimum Delivery: ${widget.Restaurant['minimumDeliveryFee']} Tk',style: SmallText(colorBlack),),
                    Text('Service Fee: ${widget.Restaurant['serviceFee']} Tk',style: SmallText(colorBlack),),
                    Text('Delivery Duration: ${widget.Restaurant['deliveryDuration']} min',style: TextHead4(colorBlack),),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: FoodLists.length,
                        itemBuilder: (BuildContext context,index){
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>FoodViewPage(FoodLists[index])));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 0),
                              child: Row(
                                children: [
                                  Container(
                                    width: width*0.6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(FoodLists[index]['foodName'],style: TextHead4(colorBlack),),
                                        Text(FoodLists[index]['foodDescription'],style: SmallText(Colors.grey),),
                                        Text('Price - ${FoodLists[index]['price']} Tk',style: TextHead1(Colors.orange),)

                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width*0.3,
                                    child: Image.network('${FoodLists[index]['imageUrl']}',width: width*0.3,fit: BoxFit.fill,),
                                  )
                                ],
                              ),
                            ),
                          );
                    })
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
