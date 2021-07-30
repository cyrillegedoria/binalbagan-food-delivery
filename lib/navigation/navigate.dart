import 'package:eatnywhere/screens/home_page.dart';
import 'package:eatnywhere/screens/sign_in_page.dart';
import 'package:eatnywhere/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/screens/add_business_page.dart';



class Navigate {
  static Map<String, Widget Function(BuildContext)> routes =   {
    '/' : (context) => WelcomePage(),
    '/sign-in' : (context) => SignInPage(),
    '/home'  : (context) => HomePage(),
    '/welcome'  : (context) => WelcomePage(),
    '/add-business'  : (context) => AddBusinessPage(),
  };
}
