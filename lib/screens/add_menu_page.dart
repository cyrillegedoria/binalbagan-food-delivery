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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.cPrimaryColor,
        title: Row(
          children: [
            Container(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user!.photoURL!),
                radius: 20,
              ),
            ),
            // Spacer(flex: 100,),
            SizedBox(width: 10,),
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
          children:<Widget> [
            Text(widget.storeId),

          ],
        ),
      ),


    );
  }




}