import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatnywhere/services/firebase_service.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    OutlineInputBorder border = OutlineInputBorder(
        borderSide: BorderSide(color: Constants.cPink, width: 3.0));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.cPrimaryColor,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [

                    FittedBox(
                      child: Image.asset("assets/images/food-logo.png"),
                    ),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: Constants.textSignInTitle,
                              style: TextStyle(
                                color: Constants.cFontPink,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              )),
                        ])),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      Constants.textSmallSignIn,
                      style: TextStyle(color: Constants.cPink),
                    ),
                    GoogleSignIn(),
                    buildRowDivider(size: size),
                    Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
                    SizedBox(
                      width: size.width * 0.8,
                      child: TextField(
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                              enabledBorder: border,
                              focusedBorder: border)),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    SizedBox(
                      width: size.width * 0.8,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                          enabledBorder: border,
                          focusedBorder: border,
                          suffixIcon: Padding(
                            child: FaIcon(
                              FontAwesomeIcons.eye,
                              size: 15,
                            ),
                            padding: EdgeInsets.only(top: 15, left: 15),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: size.height * 0.05)),
                    SizedBox(
                      width: size.width * 0.8,
                      child: OutlinedButton(
                        onPressed: () async {},
                        child: Text(Constants.textSignIn),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Constants.cPrimaryColor),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Constants.cPink),
                            side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
                      ),
                    ),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: Constants.textAcc,
                              style: TextStyle(
                                color: Constants.cFontPink,
                              )),
                          TextSpan(
                              text: Constants.textSignUp,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Constants.cFontPink,
                              )
                         ),
                       ]
                      )
                     ),
         ]
        )
      )
    );
  }

  Widget buildRowDivider({required Size size}) {
    return SizedBox(
      width: size.width * 0.8,
      child: Row(children: <Widget>[
        Expanded(child: Divider(color: Constants.cLightOrange)),
        Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              "Or",
              style: TextStyle(color: Constants.cFontPink),
            )),
        Expanded(child: Divider(color: Constants.cLightOrange)),
      ]),
    );
  }
}

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  !isLoading? SizedBox(
      height: size.height *.06,
      width: size.width * 0.6,
      child: OutlinedButton.icon(
        icon: FaIcon(FontAwesomeIcons.google),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          FirebaseService service = new FirebaseService();
          try {
           await service.signInwithGoogle();
           Navigator.pushNamedAndRemoveUntil(context, Constants.homeNavigate, (route) => false);
          } catch(e){
            if(e is FirebaseAuthException){
              showMessage(e.message!);
            }
          }
          setState(() {
            isLoading = false;
          });
        },
        label: Text(
          Constants.textSignInGoogle,
          style: TextStyle(
              color: Constants.cFontPink, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(Colors.white),
            side: MaterialStateProperty.all<BorderSide>(BorderSide.none)
        ),
      ),
    ) : CircularProgressIndicator();
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
