import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';

class AddMenuPage extends StatefulWidget{

  final String storeId;
    AddMenuPage (this.storeId, {Key? key}): super (key: key);


@override
  _AddMenuPage createState() => _AddMenuPage();


}

class _AddMenuPage extends State <AddMenuPage>{

  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference();
  final menuName = TextEditingController();
  final menuPrice = TextEditingController();

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.cPrimaryColor,
        title: Row(
          children: [
            Container(
              child: Text('Add Menu'),
            ),
            Spacer(flex: 100,),
            IconButton(
                onPressed: (){
                  Navigator.pushReplacementNamed(
                      context, Constants.addBusinessNavigate);
                },
                icon: Icon(
                  Icons.home,
                  color: Constants.cPink,
                  size: 35,
                )
            ),
            Spacer (flex: 1),
          ],
        ),
      ),
      backgroundColor: Constants.cPrimaryColor,
      body: Center(
        child: Column(
          children: <Widget>[

            SizedBox(height: 10,),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text:"RAINBREW",
                      style: TextStyle(
                        color: Constants.cPink,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      )),
                ]
                )
            ),
            SizedBox(height: 10,),
            SizedBox(
                child: Container(
                  width: size.width*.8,
                  child: TextField(
                    controller:  menuName ,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        EdgeInsets.all(16),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Constants.cPink),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Constants.cPink),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        hintText: "Menu Name",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        )
                    ),
                  ),
                )
            ),
            SizedBox(height: 10,),
            SizedBox(
                child: Container(
                  width: size.width*.8,
                  child: TextField(
                    controller:  menuName ,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        EdgeInsets.all(16),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Constants.cPink),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Constants.cPink),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        hintText: "Price",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        )
                    ),
                  ),
                )
            ),
            SizedBox(height: 10,),
            SizedBox(
             child: Container(
               width: size.width*.5,
               height: size.height*.05,
                child: TextButton(
                  onPressed: (){},
                  child: Text(
                    'Add Menu',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Constants.cPink
                    ) ,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constants.cLightGreen),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(16.0),
                          )
                      )
                  ),
                ),
              ),
            )

          ],
        )
      ),


    );
  }




}