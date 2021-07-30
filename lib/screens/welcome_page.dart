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
                Image.asset("assets/images/eatnywhere-logo.png"),
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
                              color: Constants.cLightOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0)),
                    ])),
                SizedBox(height: size.height * 0.04),
                Text(
                  Constants.textSmallSignUp,
                  style: TextStyle(
                      color: Constants.cPink,
                      fontSize: 16
                  ),
                ),
                SizedBox(height: size.height * 0.01),
            /*    SizedBox(
                  height: size.height *.06,
                  width: size.width * 0.6,
                  child: OutlinedButton(
                    onPressed: () {
                      result == null
                          ? Navigator.pushNamed(
                              context, Constants.signInNavigate)
                          : Navigator.pushReplacementNamed(
                              context, Constants.homeNavigate);
                    },
                    child: Text(Constants.textStart),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Constants.cFontPink),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.white),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                  ),
                ),
                */

                GoogleSignIn(),


              ],
            ),
          ),
        ));
  }
}
