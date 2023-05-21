import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/HomePage.dart';
import 'screens/RegistrationScreen.dart';
import 'screens/loginScreen.dart';
import 'screens/profileScreen.dart';
import 'screens/AddRestaurantScreen.dart';
import 'screens/CartScreen.dart';
import 'screens/splashScreen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Foodie());
}

class Foodie extends StatefulWidget {
  const Foodie({Key? key}) : super(key: key);

  @override
  State<Foodie> createState() => _FoodieState();
}

class _FoodieState extends State<Foodie> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/splashScreen',
        routes: {
          '/home':(context)=> Homepage(),
          '/register':(context)=>SignUp(),
          '/login':(context)=>Login(),
          '/profile':(context)=>Profile(),
          '/addRestaurant':(context)=>AddRestaurant(),
          '/cart':(context)=> CartPage(),
          '/splashScreen':(context)=>SplashScreen()
        },
      );
    }
    else{
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/home':(context)=> Homepage(),
          '/register':(context)=>SignUp(),
          '/login':(context)=>Login(),


        },
      );
    }
  }
}
