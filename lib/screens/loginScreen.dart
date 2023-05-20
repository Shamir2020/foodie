import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../style/styles.dart';
import '../firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utility/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String? errorMessage;
  Map<String,String> FormValues = {'email':"","password":""};

  Future<void> signInWithEmailAndPassword(email, password) async{
    try{
      await Auth().signInWithEmailAndPassword(email: email, password: password);
      await WriteData();
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
        ErrorToast(errorMessage);
      });

    }
  }
  InputOnChange(key1,value1) {
    FormValues.update(key1, (value) => value1);
  }
  WriteData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    String usertype='';
    print(uid);
    await db.collection('users').doc(uid).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String,dynamic>;
      print(data);
      usertype = data['usertype'];
    });
    await prefs.setString('usertype', usertype);

  }
  FormOnSubmit()async{
    if (FormValues['email'] == ''){
        ErrorToast('Email cannot be empty!!');
    }
    else if (FormValues['password'] ==''){
      ErrorToast('Password cannot be empty!!');
    }
    else{
      await signInWithEmailAndPassword(FormValues['email'], FormValues['password']);
      SuccessToast('Sign in Successful!');
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;


    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width*0.1,vertical: height*0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/logo.png'),
                SizedBox(height: height*.05,),
                Text('Welcome to foodie',style: TextHead1(colorBlack),),
                SizedBox(height: height*0.005,),
                Text('Enter your information to Login',style: NormalText(colorBlack),),
                SizedBox(height: height*0.07,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0,color: Colors.greenAccent)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0,color: Colors.redAccent)
                          )
                      ),
                      onChanged: (value){
                        InputOnChange('email', value);
                      },
                    ),
                    SizedBox(height: height*0.05,),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0,color: Colors.greenAccent)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0,color: Colors.redAccent)
                          )
                      ),
                      onChanged: (value){
                        InputOnChange('password', value);
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: height*0.05,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(double.infinity, height*0.055),
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black
                        ),
                        onPressed: (){
                          FormOnSubmit();
                        },
                        child: Text('Login',style: TextStyle(fontFamily: 'Poppins',fontSize: 23,fontWeight: FontWeight.w600),)),
                    SizedBox(height: height*0.05,),
                    Column(
                      children: [
                        InkWell(
                          onTap: (){},
                          child: Text('Forgot your password?',style: TextHead5(Colors.grey),),
                        ),
                        SizedBox(height: height*0.04,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?",style: SmallText(colorBlack),),
                            SizedBox(width: width*0.02,),
                            InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text('Create a new account',style: SmallText(Colors.greenAccent),),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        )

    );
  }
}
