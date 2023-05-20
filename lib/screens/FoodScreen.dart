import 'package:flutter/material.dart';
import '../style/styles.dart';
import '../utility/utility.dart';
class FoodViewPage extends StatefulWidget {
  var Food;
  FoodViewPage(this.Food,{Key? key}) : super(key: key);

  @override
  State<FoodViewPage> createState() => _FoodViewPageState();
}

class _FoodViewPageState extends State<FoodViewPage> {

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var food;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.Food['imageUrl'],height: height*0.3,width: width,),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(widget.Food['foodName'],style: TextHead1(colorBlack),),
                  SizedBox(height: 10.0,),
                  Text(widget.Food['foodDescription'],style: TextHead4(Colors.grey),),
                  SizedBox(height: 10.0,),
                  Text('Price - ${widget.Food['price']} Tk',style: TextHead1(Colors.orange),),
                  SizedBox(height: 30.0,),
                  ElevatedButton(
                      onPressed: (){
                        food = widget.Food;
                        if (food['quantity'] == null){
                          food['quantity'] = 1;
                        }
                        else{
                          food['quantity'] += 1;
                        }
                        addToCart(food);

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(255, 0, 123, 1),
                        foregroundColor: Colors.white
                      ),
                      child: Text('Add to Cart',style: TextHead4(colorWhite),))

                ],
              ),
            )
          ],
        )
      ),
    );
  }
}

