import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatnywhere/services/firebase_service.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


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
    return  !isLoading? Column(
      children:<Widget> [
        Text(
          Constants.textSmallSignUp,
          style: TextStyle(
              color: Colors.grey,
              fontSize: 16
          ),
        ),
        SizedBox(height:3),
        SizedBox(
          height: size.height *.045,
          width: size.width * 0.6,
          child: OutlinedButton.icon(
            icon: FaIcon(FontAwesomeIcons.google, color: Colors.blueAccent,),
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
                  color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Constants.cLightOrange),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    )
                )
            ),
          ),
        )

      ],
    )
        : CircularProgressIndicator(color: Constants.cLightOrange,);
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