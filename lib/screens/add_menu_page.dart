import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
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
  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');

  final menuName = TextEditingController();
  final menuPrice = TextEditingController();

  late Map<dynamic, dynamic> _mapVal;
  late String storeName="";
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storeName==""){
      returnRef().then(
              (String i) => setState((){storeName=i;})
      );
    }
  }

  Future<String> returnRef () async => referenceDatabase.child('${widget.storeId}').once().then((snapshot){
    _mapVal = snapshot.value;
    //storeName = _mapVal.values.toList()[1];
    storeName = _mapVal['StoreName'];
    //print('StoreName: ${storeName}');
   // print('MapVal: ${_mapVal['MenuList']}');
    return storeName;
  });

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              child: Column(
                children: <Widget>[

                  SizedBox(height: 10,),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text:'${storeName.toUpperCase()}', //change to a StoreName
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
                                borderSide: BorderSide(color: Colors.white),
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
                          controller:  menuPrice ,
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
                                borderSide: BorderSide(color: Colors.white),
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
                        onPressed: (){

                          referenceDatabase
                              .child('${widget.storeId}')
                              .child('MenuList')
                              .update({menuName.text:menuPrice.text})
                              .asStream();

                          menuName.clear();
                          menuPrice.clear();

                        },
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
                  ),
                  SizedBox(height: 10,),
                  FirebaseAnimatedList(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      query: referenceDatabase.child('${widget.storeId}').child('MenuList'),
                      itemBuilder: (BuildContext context,
                          DataSnapshot snapshot,
                          Animation<double> animation,
                          int index)
                      {



                        return  new ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),

                          onPressed:() {},

                          child: new ListTile(
                            tileColor: Colors.transparent,
                            dense: true,
                            visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                            minVerticalPadding:12,
                            title: new Text(
                              '${snapshot.key}'
                                  ' : '
                                  '${snapshot.value}',
                              style: TextStyle(  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.cPink
                              ),
                            ),
                            trailing: IconButton(icon: Icon(Icons.delete),
                              onPressed: () => referenceDatabase.child('${widget.storeId}').child('MenuList').child('${snapshot.key}').remove(),
                            ),
                          ),
                        );
                      }
                  ),


                ],
              )
          ),
        ),
      )


    );
  }




}