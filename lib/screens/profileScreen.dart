import 'package:flutter/material.dart';
import '../style/styles.dart';
import '../firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Add a Food.dart';
import '../utility/utility.dart';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final db = FirebaseFirestore.instance;
  bool loading = true;
  String restaurantName='';
  Map<String,dynamic> Userdata = {'first name':"",'last name':"",'phone':"",'email':"",'usertype':""};

  Future<dynamic> getRestaurantName() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    try{
      var name = await FirebaseFirestore.instance.collection('restaurants').doc(uid).get();
      Map<String, dynamic>? a = name.data();
      setState(() {
        restaurantName = a?['restaurantName'];
      });
    }
    catch(error){
      print('');
    }

  }

  Future<dynamic> getUserDetails(String email) async{
      final snapshot = await db.collection('users').where('email',isEqualTo: email).get();
      print(snapshot);
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      print(uid);
      await db.collection('users').doc(uid).get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String,dynamic>;
        print(data);
        setState(() {
          Userdata.update('first name', (value) => data['first name']);
          Userdata.update('last name', (value) => data['last name']);
          Userdata.update('email', (value) => data['email']);
          Userdata.update('phone', (value) => data['phone']);
          Userdata.update('usertype', (value) => data['usertype']);
          loading = false;
        });
      });
  }


  Future<void> signOut() async{
    try{
      await Auth().signOut();
      SuccessToast('Logout Succesful!');
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } on FirebaseAuthException catch (e){
      setState(() {
        ErrorToast('Logout failed!!!');
      });

    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getUserDetails('shamirroy49@gmail.com');
    getRestaurantName();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    
    print(Auth().currentUser?.displayName);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Text('Profile',style: TextHead5(colorBlack),),
      ),
      body: loading?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        child: Column(
          children: [
            CustomTile('Name', Userdata['first name']+' '+Userdata['last name']),
            CustomTile('Email', Userdata['email']),
            CustomTile('Mobile Number', Userdata['phone']),
            CustomTile('User Type', Userdata['usertype']),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 0, 123, 1),
                  foregroundColor: Colors.black,
                  fixedSize: Size(width*.95, 45),
                ),
                child: Text('Logout',style: TextHead4(colorWhite),)),
            SizedBox(height: 20,),
            if (Userdata['usertype']! == 'Seller') ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/addRestaurant');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  fixedSize: Size(width*0.95, 45),
                ),
                child: Text('Add a Restaurant',style: TextHead4(colorWhite),)),
            SizedBox(height: 20,),
            if (Userdata['usertype']! == 'Seller' && restaurantName != '') ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddFood(restaurantName)));

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  fixedSize: Size(width*0.95, 45),
                ),
                child: Text('Add a Food',style: TextHead4(colorWhite),))
          ],
        ),
      ),
    );
  }
}

CustomTile(key,value){
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Material(
      elevation: 1.5,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(key,style: TextHead5(colorBlack),),
            SizedBox(height: 10,),
            Text(value)
          ],
        ),
      ),

    ),
  );
}