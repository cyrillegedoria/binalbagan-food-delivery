import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //colors
  static const cPrimaryColor = Color(0xFFc7ceea);
  static const cMint = Color(0xFFb5ead7);
  static const cLightGreen = Color(0xFFe2f0cb);
  static const cLightOrange = Color(0xFFffdac1);
  static const cFontPink = Color(0xFFffb7b2);
  static const cPink = Color(0xFFff9aa2);




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
