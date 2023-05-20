import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../style/styles.dart';
import '../firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utility/utility.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? errorMessage;
  Map<String,String> FormValues = {'email':"",'fname':'','lname':'','phone':'',"password1":"","password2":"",'usertype':""};

  Future<void> createUserWithEmailAndPassword(email, password) async{
    try{
      await Auth().createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
        ErrorToast(errorMessage);
      });

    }
  }
  Future<void> addUserDetails() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    print(uid);
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'first name':FormValues['fname'],
        'last name':FormValues['lname'],
        'phone':FormValues['phone'],
        'email':FormValues['email'],
        'usertype':FormValues['usertype']
    });
  }
  InputOnChange(key1,value1) {
    setState(() {
      FormValues.update(key1, (value) => value1);
    });
  }
  FormOnSubmit() async{
    if (FormValues['email'] == ''){
      ErrorToast('Email cannot be empty!!');
    }
    else if (FormValues['password1'] ==''){
      ErrorToast('Password cannot be empty!!');
    }
    else if (FormValues['password2'] ==''){
      ErrorToast('Password cannot be empty!!');
    }
    else if (FormValues['password1'] != FormValues['password2']){
      ErrorToast('Password do not match!!');
    }
    else{
      await createUserWithEmailAndPassword(FormValues['email'], FormValues['password1']);
      await addUserDetails();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(

          padding: EdgeInsets.symmetric(horizontal: width*0.1,vertical: height*0.09),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('images/logo.png',height: height*0.08,),
              SizedBox(height: height*.04,),
              Text('Welcome to foodie',style: TextHead1(colorBlack),),
              SizedBox(height: height*0.005,),
              Text('Enter your information to Sign Up',style: NormalText(colorBlack),),
              SizedBox(height: height*0.03,),
              TextFormField(
                decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: height*0.06,
                    ),
                    labelText: 'First Name',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.greenAccent)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.redAccent)
                    )
                ),
                onChanged: (value){
                  InputOnChange('fname', value);
                },
              ),
              SizedBox(height: height*0.015,),
              TextFormField(
                decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: height*0.06,
                    ),
                    labelText: 'Last Name',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.greenAccent)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.redAccent)
                    )
                ),
                onChanged: (value){
                  InputOnChange('lname', value);
                },
              ),
              SizedBox(height: height*0.015,),
              TextFormField(
                decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: height*0.06,
                    ),
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
              SizedBox(height: height*0.015,),
              TextFormField(
                decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: height*0.06,
                    ),
                    labelText: 'Phone',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.greenAccent)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.redAccent)
                    )
                ),
                onChanged: (value){
                  InputOnChange('phone', value);
                },
              ),
              DropdownButton(
                isExpanded: true,
                value: FormValues['usertype'],
                  items: [
                    DropdownMenuItem(value:'' ,child: Text('I am a')),
                    DropdownMenuItem(value: 'Seller',child: Text('Seller')),
                    DropdownMenuItem(value: 'Customer',child: Text('Customer'))
                  ],
                  onChanged: (value){
                  InputOnChange('usertype', value);

              }),
              SizedBox(height: height*0.015,),
              TextFormField(

                decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: height*0.06,
                    ),
                    labelText: 'Password',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.greenAccent)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.redAccent)
                    )
                ),
                onChanged: (value){
                  InputOnChange('password1', value);
                },
                obscureText: true,
              ),
              SizedBox(height: height*0.015,),
              TextFormField(
                decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: height*0.06,
                    ),
                    labelText: 'Password again',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.greenAccent)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.redAccent)
                    )
                ),
                onChanged: (value){
                  InputOnChange('password2', value);
                },
                obscureText: true,

              ),
              SizedBox(height: height*0.015,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      fixedSize: Size(double.infinity, height*0.05)
                  ),
                  onPressed: () async{
                    await FormOnSubmit();
                  },
                  child: Text('Sign Up',style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600,fontSize: 20),)),
              SizedBox(height: height*0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',style: TextHead5(colorBlack),),
                  SizedBox(width: width*0.02,),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    child: Text('Login here',style: TextHead5(Colors.greenAccent),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
