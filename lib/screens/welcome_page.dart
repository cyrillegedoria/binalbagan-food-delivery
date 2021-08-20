import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eatnywhere/screens/sign_in_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User? result = FirebaseAuth.instance.currentUser;
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
                              color: Constants.cPink,
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0)),
                    ])),
                SizedBox(height: size.height * 0.1),
                Text(
                  Constants.textSmallSignUp,
                  style: TextStyle(
                      color: Constants.cPink,
                      fontSize: 16
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                GoogleSignIn(),
              ],
            ),
          ),
        )
    );
  }
}
