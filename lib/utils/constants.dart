import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //colors
  static const cPrimaryColor = Color(0xFFc7ceea);
  static const cMint = Color(0xFFb5ead7);
  static const cLightGreen = Color(0xFFe2f0cb);
  static const cLightOrange = Color(0xFFffdac1);
  static const cFontPink = Color(0xCCffb7b2);
  static const cPink = Color(0xCCff9aa2);

  //static const cPrimaryColor = Color(0xFF20639b);
  //static const cMint = Color(0xFF3caea3);
  //static const cLightGreen = Color(0xFFf6d55c);
  //static const cLightOrange = Color(0xFFed553b);
  //static const cFontPink = Color(0xFF173f5f);
 // static const cPink = Color(0xFFff9aa2);

  //static const cPrimaryColor = Color(0xFFeaac8b);
  //static const cMint = Color(0xFFb56576);
 // static const cLightGreen = Color(0xFFe56b6f);
 // static const cLightOrange = Color(0xFF6d597a);
 // static const cFontPink = Color(0xFF355070);
  //static const cPink = Color(0xFFae3c60);

  //text
  static const title = "Eatnywhere";
  static const textIntro = "Order your favorite\n";
  static const textIntroDesc1 = "Food anywhere in\n";
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
