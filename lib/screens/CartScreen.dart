import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/utility/utility.dart';
import '../style/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var CartList = [];
  var c = 0;
  Map<String,String> FormValues = {
    'deliveryAddress':""
  };
  InputOnChange(mapkey,mapvalue){
    setState(() {
      FormValues.update(mapkey, (value) => mapvalue);
    });
  }

  FormOnSubmit()async{
    if (FormValues['deliveryAddress'] == ''){
      ErrorToast('Delivery Address required!');
    }
    else{

    }
  }
  FetchCartData() async{
    var db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    await db.collection("cart").where("uid", isEqualTo: uid).get().then(
          (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          setState(() {
            CartList.add(docSnapshot.data());
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

  }

  DeleteDataInside(docSnapshot) async{
    var db = FirebaseFirestore.instance;
    await db.collection("cart").doc(docSnapshot.id).delete().then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );
    FetchCartData();
  }

  DeleteData(foodName) async{
    var db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    var docId;
    await db.collection("cart").where("uid", isEqualTo: uid).get().then(
          (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          if (docSnapshot.data()['foodName '] == foodName){
              docId = docSnapshot.id;

          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    await db.collection("cart").doc(docId).delete().then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );
    setState(() {
      c += 1;
    });

  }



  @override
  void initState() {
    // TODO: implement initState
    FetchCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Cart',style: TextHead4(colorBlack),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:CartList.length,itemBuilder: (BuildContext context,index){
              return Row(
                children: [
                  Image.network('${CartList[index]['imageUrl']}',width: width*0.3,height: height*0.1,),
                  SizedBox(width: 5,),
                  Text(CartList[index]['foodName'],style: SmallText(colorBlack),),
                  SizedBox(width: 5,),
                  Text('Tk: ${CartList[index]['totalPrice']}'),
                  SizedBox(width: 5,),
                  Text('Qty:${CartList[index]['quantity']}'),
                  IconButton(onPressed: (){
                    DeleteData(CartList[index]['foodName']);

                  }, icon: Icon(Icons.delete))
                ],
              );
            }),
            SizedBox(height: 50,),
            Container(
              width: width*0.8,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 45
                        ),
                        labelText: 'Delivery Address',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.redAccent)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.greenAccent)
                        )
                    ),
                    onChanged: (value){
                      InputOnChange('deliveryAddress', value);

                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(

                onPressed: (){
                  FormOnSubmit();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(width*0.8, 45),
                  backgroundColor: Color.fromRGBO(255, 0, 123, 1),
                  foregroundColor: Colors.white
                ),
                child: Text('Place Order',style: TextHead4(colorWhite),))
          ],
        )
      )
    );
  }
}
