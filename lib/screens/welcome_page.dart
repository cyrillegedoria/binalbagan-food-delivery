import 'dart:async';
import 'package:eatnywhere/services/sqflite_search_query.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eatnywhere/services/google_sign_in.dart';

class WelcomePage extends StatefulWidget {
  late bool isUserSigned=true;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  _WelcomePageState createState() => _WelcomePageState();
}



class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CgDbHelper();
    startTimer();
  }

  void startTimer() { //Redirect after 3s
    Timer(Duration(seconds: 3), () {
      setState(() {
        navigateUser();
      });
    });
  }

  void navigateUser() async{
    try{
      if(widget.user!.displayName! != ""){
        Navigator.pushNamedAndRemoveUntil(context, Constants.homeNavigate, (route) => false);
      }
      else{
        setState(() {
          widget.isUserSigned = false;
        });
      }
    }
    catch(e){
      setState(() {
        widget.isUserSigned = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

     return Scaffold(
         backgroundColor: Constants.cPrimaryColor,
         body: AnnotatedRegion<SystemUiOverlayStyle>(
           value: Constants.statusBarColor,
           child: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [

                 Container(
                   width: 200,
                   height: 250,
                   child: FittedBox(
                     child: Image.asset("assets/images/eatnywhere-logo.png"),
                   ),
                 ),
                 RichText(
                     textAlign: TextAlign.center,
                     text: TextSpan(children: <TextSpan>[
                       TextSpan(
                           text: Constants.textIntro,
                           style: TextStyle(
                             color: Colors.white,
                             fontWeight: FontWeight.bold,
                             fontSize: 30.0,
                           )),
                       TextSpan(
                           text: Constants.textIntroDesc1,
                           style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: 30.0)),
                       TextSpan(
                           text: Constants.textIntroDesc2,
                           style: TextStyle(
                               color: Constants.cRed,
                               fontWeight: FontWeight.bold,
                               fontSize: 40.0)),
                     ])),
                 SizedBox(height: size.height * 0.1),

                 if(widget.isUserSigned == false)(){
                   return GoogleSignIn();
                 }()
                 else if(widget.isUserSigned == true)(){
                   return CircularProgressIndicator(color: Constants.cLightOrange,);
                 }()

               ],
             ),
           ),
         )
     );

  }
}

