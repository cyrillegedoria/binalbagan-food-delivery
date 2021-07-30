import 'package:eatnywhere/services/firebase_service.dart';
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
              child: CircleAvatar(
                backgroundImage: NetworkImage(user!.photoURL!),
                radius: 20,
              ),
            ),
            // Spacer(flex: 100,),
            SizedBox(width: 10,),
            Container(
              child: Text('Add Business and Menus'),
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
      body: ListView(
        padding: const EdgeInsets.all(10),
        //shrinkWrap: true ,
        children: <Widget>[

          SizedBox(height: 30,),
         Container(
            color: Colors.white,
            child: TextField(
              controller:  storeNameTf ,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  hintText: "Store name",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  )
              ),
            ),
          ),
          SizedBox(height: 10,),
         /* Container(
            color: Colors.white,
            child: TextField(
              controller:  menuTf,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  hintText: "Menu 1",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  )
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            color: Colors.white,
            child: TextField(
              controller:  menuPriceTf,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  hintText: "Menu 1 Price",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  )
              ),
            ),
          ),*/
          SizedBox(height: 10,),
          Container(
            height: size.height *.065,

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
                      .child('Stores')
                      .set({'StoreName':storeNameTf.text})
                      .asStream();

                  Fluttertoast.showToast(msg: "Success!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                  );
                }

                storeNameTf.clear();
               // menuTf.clear();
               // menuPriceTf.clear();

               // printFirebase();

              },

              child: Text(
                  'SAVE',
                  style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: Constants.cPink
                  ) ,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Constants.cLightGreen),

              ),
            ),
          ),
          SizedBox(height: 10,),
          FirebaseAnimatedList(

              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              query:  referenceDatabase.child('StoresList'),
              itemBuilder: (BuildContext context,  DataSnapshot snapshot,
              Animation<double> animation, int index) {

                  return  new ListTile(
                    tileColor: Colors.white,
                    dense: true,
                    //enabled: true,
                    hoverColor: Colors.black,
                    visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                    minVerticalPadding: 10,

                    title: new Text(
                                '${snapshot.value['Stores']['StoreName'].toString().toUpperCase()}',
                                     style: TextStyle(  fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Constants.cPink
                                      ),
                    ),
                    trailing: IconButton(icon: Icon(Icons.delete),
                      onPressed: () => referenceDatabase.child('StoresList').child('${snapshot.key}').remove(),
                    ),

                  );

          }),


        ],
      ),
    );

  }



}


