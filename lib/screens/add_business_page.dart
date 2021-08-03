import 'package:eatnywhere/screens/add_menu_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AddBusinessPage extends StatefulWidget{

  late final FirebaseApp app;

  @override
  _AddBusinessPage createState() => _AddBusinessPage();


}

class _AddBusinessPage extends State <AddBusinessPage>{
  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference();
  final storeNameTf = TextEditingController();
  final menuTf= TextEditingController();
  final menuPriceTf= TextEditingController();


  @override
  Widget build(BuildContext context) {


    final storesRef = referenceDatabase.reference();


    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.cPrimaryColor,
        title: Row(
          children: [

            Container(
              child: Text('Add Business'),
            ),
            Spacer(flex: 100,),
            IconButton(
                onPressed: (){
                      Navigator.pushReplacementNamed(
                      context, Constants.homeNavigate);
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

            SizedBox(height: 10,),
            SizedBox(
              child: Container(
                width: size.width*.8,
                child: TextField(
                  controller:  storeNameTf ,
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
                      hintText: "Store Name",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      )
                  ),
                ),
              ),
            ),

            SizedBox(height: 10,),

            SizedBox(
              child: Container(

                width: size.width*.5,
                height: size.height*.05,
                child: TextButton(
                  onPressed: (){
                    if (storeNameTf.text=="")
                    {
                      Fluttertoast.showToast(msg: "Please fill the form.",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                      );
                    }
                    else {
                      storesRef
                          .child('StoresList')
                          .push()
                          .set({'StoreName':storeNameTf.text})
                          .asStream();
                      Fluttertoast.showToast(msg: "Success!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                      );
                    }
                    storeNameTf.clear();
                  },
                  child: Text(
                    'Save',
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
            ),

            SizedBox(height: 10,),

            Container(
              child: Expanded(
                child: FirebaseAnimatedList(
                    shrinkWrap: false,
                    query: referenceDatabase.child('StoresList'),
                    itemBuilder: (BuildContext context,
                        DataSnapshot snapshot,
                        Animation<double> animation,
                        int index)
                    {
                      return  new ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                        ),

                        onPressed:() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMenuPage('${snapshot.key}')));

                          // referenceDatabase.child('StoresList').child('${snapshot.key}').update({"Menu":"Burger"});

                          /*referenceDatabase
                          .child('StoresList')
                          .child('${snapshot.key}')
                          .child("MenuList")
                          .update({'Fries':"50"})
                          .asStream();
                      */
                        },

                        child: new ListTile(
                          tileColor: Colors.transparent,
                          dense: true,
                          //enabled: true,
                          //hoverColor: Colors.black,
                          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                          minVerticalPadding:13,
                          title: new Text(
                            '${snapshot.value['StoreName'].toString().toUpperCase()}',
                            style: TextStyle(  fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Constants.cPink
                            ),
                          ),
                          trailing: IconButton(icon: Icon(Icons.delete),
                            onPressed: () => referenceDatabase.child('StoresList').child('${snapshot.key}').remove(),
                          ),
                        ),
                      );
                    }
                ),
              ),
            )


          ],
        )

      )
    );

  }



}

//test


