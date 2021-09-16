import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //colors
 // static const cPrimaryColor = Color(0xFFc7ceea);
  //static const cMint = Color(0xFFb5ead7);
  //static const cLightGreen = Color(0xFFe2f0cb);
  //static const cLightOrange = Color(0xFFffdac1);
  //static const cFontPink = Color(0xCCffb7b2);
  //static const cPink = Color(0xCCff9aa2);

  static const cPrimaryColor = Color(0xFFedf0f1);
  static const cLightBlue = Color(0xFF22afcd);
  static const cLightOrange = Color(0xFFffcfb4);
  static const cOrange = Color(0xFFfba74f);
  static const cLightGreen = Color(0xFFd5e978);
  static const cRed = Color(0xffcb3420);

  //static const cPrimaryColor = Color(0xFFeaac8b);
  //static const cMint = Color(0xFFb56576);
 // static const cLightGreen = Color(0xFFe56b6f);
 // static const cLightOrange = Color(0xFF6d597a);
 // static const cFontPink = Color(0xFF355070);
  //static const cPink = Color(0xFFae3c60);

  //text
  static const title = "Eatnywhere";
  static const textIntro = "Eat your favorite\n";
  static const textIntroDesc1 = "food anywhere in\n";
  static const textIntroDesc2 = "BINALBAGAN";
  static const textSmallSignUp = "Register with your Google account.";
  static const textSignIn = "Sign In";
  static const textStart = "Get Started";
  static const textSignInTitle = "Welcome back!";
  static const textSmallSignIn = "You've been missed";
  static const textSignInGoogle = "Sign In With Google";
  static const textAcc = "Don't have an account? ";
  static const textSignUp = "Sign Up here";
  static const textHome = "Home";

  //navigate
  static const signInNavigate = '/sign-in';
  static const homeNavigate = '/home';
  static const welcomeNavigate = '/welcome';
  static const addBusinessNavigate = '/add-business';
  static const addMenuNavigate = '/add-menu';

  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.cPrimaryColor,
      statusBarIconBrightness: Brightness.dark);
}
