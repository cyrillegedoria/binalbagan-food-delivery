import 'package:eatnywhere/screens/add_business_page.dart';
import 'package:eatnywhere/screens/select_menu_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:eatnywhere/services/firebase_service.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eatnywhere/custom widgets/custom_list.dart';
import 'package:eatnywhere/services/sqflite_search_query.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';



class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');
  List<Map<dynamic, dynamic>> lists = [];// added for search
  int _storeCount = 0;
  late int _indexOfStores =0;
  late Map<dynamic, dynamic> _mapVal;
  final searchTf = TextEditingController();


  @override
  void initState() {
    super.initState();

    if  (_storeCount == 0 )
      {
        returnIndex().then(
                (int i) => setState((){_storeCount=i;})
        );
      }
    searchTf.addListener(_onSearchChanged);
  }

  @override
  void dispose(){
    searchTf.removeListener(_onSearchChanged);
    searchTf.dispose();
    super.dispose();
  }

  _onSearchChanged(){
    setState(() {});
  }


  Future<int> returnIndex () async => referenceDatabase.once().then((snapshot){
    Map<dynamic, dynamic> mapVal;
    mapVal = snapshot.value;
    _storeCount = mapVal.length;
    _mapVal = snapshot.value;
    return _storeCount;
  });


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');
    referenceDatabase.once().then((DataSnapshot snapshot) {
      _mapVal = snapshot.value;
    });

    return Scaffold(
      backgroundColor: Constants.cPrimaryColor,
      appBar: AppBar(
        backgroundColor: Constants.cPrimaryColor,
        title: Row(
         children: [
          Container(
           child: CircleAvatar(
             backgroundImage: NetworkImage(user!.photoURL!),
              radius: 15,
            ),
           ),
          // Spacer(flex: 100,),
           SizedBox(width: 10,),
           Container(
            child: Text(user!.displayName!),
           ),
           Spacer(flex: 10,),
           IconButton(
               onPressed: (){

                 Navigator.push(context,MaterialPageRoute(builder: (context) => AddBusinessPage()));

                 },
               icon: Icon(
                 Icons.add_business,
                 size: 30,
               )
           ),
           Spacer (flex: 1),
           IconButton(
              icon: Icon(
              Icons.logout,
              color: Constants.cPink,
                size: 30,
              ),
              onPressed: () async {
              FirebaseService service = new FirebaseService();
              await service.signOutFromGoogle();
              Navigator.pushReplacementNamed(
              context, Constants.welcomeNavigate);
                },
             ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30 ,),
                      SizedBox(
                        width: size.width * .8,
                        child: TextField(
                          controller: searchTf,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                              EdgeInsets.all(20),
                              //enabledBorder: border,
                              //focusedBorder: border,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              suffixIcon: Padding(
                                child: FaIcon(
                                  FontAwesomeIcons.search,
                                  size: 25,
                                  color: Constants.cFontPink,
                                ),
                                padding: EdgeInsets.only(top: 10, left: 10),
                              ),
                              hintText: "Search food & stores",
                              hintStyle: TextStyle(
                                color: Constants.cFontPink,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              )
                          ),

                        ),
                      ),
                      SizedBox(height: 30),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text:"Food Stores in Binalbagan",
                                style: TextStyle(
                                  color: Constants.cPink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                )),
                          ]
                          )
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),

                  FutureBuilder(

                      future: searchTf.text==""? referenceDatabase.orderByChild("StoreName").startAt("").once() : referenceDatabase.orderByChild("StoreName").startAt(searchTf.text.toUpperCase()).endAt(searchTf.text).once(),

                      builder: (context, AsyncSnapshot<DataSnapshot> snapshot){

                          try{
                            lists.clear();
                            Map<dynamic, dynamic> values = snapshot.data!.value;
                            values.forEach((key, values) {
                              lists.add(values);
                              //print("This is from List ${values.}");
                            });

                            return new ListView.builder(
                                shrinkWrap: true,
                                itemCount: lists.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(lists[index]["StoreName"]),
                                        Text(lists[index]["StoreAddress"]),
                                      ],
                                    ),
                                  );

                                });

                          }
                          catch(e){
                             return CircularProgressIndicator();
                          }
                      }
                  )
                ],
                )
            ),
          ),
        ),

    );
  }
}
