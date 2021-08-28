import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  final menuDescription = TextEditingController();

  final beverageName = TextEditingController();
  final beveragePrice = TextEditingController();
  final beverageDescription = TextEditingController();

  final extraName = TextEditingController();
  final extraPrice = TextEditingController();
  final extraDescription = TextEditingController();

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
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Constants.cPrimaryColor,
              title: Row(
                children: [
                  Container(
                    child: Text('Add Menu - ${storeName.toUpperCase()}'),
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
                        size: 30,
                      )
                  ),
                  Spacer (flex: 1),
                ],
              ),
              bottom: TabBar(
                indicatorColor: Constants.cPink,
                indicatorWeight: 3.0,
                labelColor: Constants.cPink,
                labelPadding: EdgeInsets.only(top:1, bottom:1),
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  //fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(
                    text: 'Main',
                    icon: Icon(
                      Icons.restaurant_menu,
                    ),
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Tab(
                    text: 'Beverages',
                    icon: Icon(
                      Icons.emoji_food_beverage_outlined,
                    ),
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Tab(
                    text: 'Others',
                    icon: Icon(
                      Icons.post_add_outlined,
                    ),
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                ],
              ),
            ),
            backgroundColor: Constants.cPrimaryColor,
            body: TabBarView(
              children: [
                //Tab 0, Main
                  SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                        child: Column(
                          children: <Widget>[

                            SizedBox(height: 10,),
                            SizedBox(
                                child: Container(
                                  width: size.width*.7,
                                  height: size.height*0.045,
                                  child: TextField(
                                    controller:  menuName ,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                        EdgeInsets.all(15),
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
                                          fontSize: 16,
                                        )
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 8,),
                            SizedBox(
                                child: Container(
                                  width: size.width*.7,
                                  height: size.height*0.045,
                                  child: TextField(
                                    controller:  menuPrice ,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                        EdgeInsets.all(15),
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
                                          fontSize: 16,
                                        )
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 8,),
                            SizedBox(
                                child: Container(
                                  width: size.width*.7,
                                  height: size.height*0.045,
                                  child: TextField(
                                    controller:  menuDescription ,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                        EdgeInsets.all(15),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Constants.cPink),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        hintText: "Description",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 10,),
                            SizedBox(
                              child: Container(
                                width: size.width*.5,
                                //height: size.height*.05,
                                child: TextButton(
                                  onPressed: (){

                                    if (menuName.text=="" || menuPrice.text=="" || menuDescription.text=="")
                                    {
                                      Fluttertoast.showToast(msg: "Please fill the form.",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                      );
                                    }
                                    else{
                                      referenceDatabase
                                          .child('${widget.storeId}')
                                          .child('MenuList')
                                          .child('${menuName.text}')
                                          .update({'Name':menuName.text,'Description':menuDescription.text,'Price':menuPrice.text})
                                          .asStream();

                                      menuDescription.clear();
                                      menuName.clear();
                                      menuPrice.clear();
                                    }

                                  },
                                  child: Text(
                                    'Add Menu',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.cPink
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
                                  return  Card(
                                    child: Row(
                                      children:<Widget> [

                                        new Container(
                                          width: 100,
                                          height: 80,
                                          child: FittedBox(
                                            fit:BoxFit.fill,
                                            child: Image.asset("assets/images/pizza.png"),
                                          ),
                                        ),

                                        Container(  //Divider
                                          height: 50.0,
                                          width: 1.0,
                                          color: Colors.black54,
                                          margin: const EdgeInsets.only(left:0, right: 10.0),
                                        ),
                                        new Column(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Column (
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Container (
                                                    child: new Text('${snapshot.value['Name']}'' : ''${snapshot.value['Price']}',
                                                      style: TextStyle(  fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Constants.cPink
                                                      ),
                                                    )
                                                ),
                                                new Container(height: 5.0,),
                                                new Text('${snapshot.value['Description']}',
                                                  style: TextStyle(  fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Constants.cPink,
                                                  ),
                                                ),
                                                //  new Divider(height: 15.0,color: Colors.red,),
                                              ],
                                            )
                                          ],
                                        ),
                                        new Spacer(flex: 1),
                                        new IconButton(
                                          icon: Icon(Icons.delete, color: Colors.grey,),
                                          onPressed: () => referenceDatabase.child('${widget.storeId}').child('MenuList').child('${snapshot.key}').remove(),
                                        ),

                                      ],
                                    ),
                                  );
                                }
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                //end Tab 0, Main

                //Tab 1, Beverages
                SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                        child: Column(
                          children: <Widget>[

                            SizedBox(height: 10,),
                            SizedBox(
                                child: Container(
                                  width: size.width*.7,
                                  height: size.height*0.045,
                                  child: TextField(
                                    controller:  beverageName ,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                        EdgeInsets.all(15),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Constants.cPink),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        hintText: "Beverage Name",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 8,),
                            SizedBox(
                                child: Container(
                                  width: size.width*.7,
                                  height: size.height*0.045,
                                  child: TextField(
                                    controller:  beveragePrice ,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                        EdgeInsets.all(15),
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
                                          fontSize: 16,
                                        )
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 8,),
                            SizedBox(
                                child: Container(
                                  width: size.width*.7,
                                  height: size.height*0.045,
                                  child: TextField(
                                    controller:  beverageDescription ,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                        EdgeInsets.all(15),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Constants.cPink),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        hintText: "Description",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 10,),
                            SizedBox(
                              child: Container(
                                width: size.width*.5,
                                //height: size.height*.05,
                                child: TextButton(
                                  onPressed: (){

                                    if (beverageName.text=="" || beveragePrice.text=="" || beverageDescription.text=="")
                                    {
                                      Fluttertoast.showToast(msg: "Please fill the form.",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                      );
                                    }
                                    else{
                                      referenceDatabase
                                          .child('${widget.storeId}')
                                          .child('BeverageList')
                                          .child('${beverageName.text}')
                                          .update({'Name':beverageName.text,'Description':beverageDescription.text,'Price':beveragePrice.text})
                                          .asStream();

                                      beverageDescription.clear();
                                      beverageName.clear();
                                      beveragePrice.clear();
                                    }

                                  },
                                  child: Text(
                                    'Add Menu',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.cPink
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
                                query: referenceDatabase.child('${widget.storeId}').child('BeverageList'),
                                itemBuilder: (BuildContext context,
                                    DataSnapshot snapshot,
                                    Animation<double> animation,
                                    int index)
                                {
                                  return  Card(
                                    child: Row(
                                      children:<Widget> [

                                        new Container(
                                          width: 100,
                                          height: 80,
                                          child: FittedBox(
                                            fit:BoxFit.fill,
                                            child: Image.asset("assets/images/pizza.png"),
                                          ),
                                        ),

                                        Container(  //Divider
                                          height: 50.0,
                                          width: 1.0,
                                          color: Colors.black54,
                                          margin: const EdgeInsets.only(left:0, right: 10.0),
                                        ),
                                        new Column(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Column (
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Container (
                                                    child: new Text('${snapshot.value['Name']}'' : ''${snapshot.value['Price']}',
                                                      style: TextStyle(  fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Constants.cPink
                                                      ),
                                                    )
                                                ),
                                                new Container(height: 5.0,),
                                                new Text('${snapshot.value['Description']}',
                                                  style: TextStyle(  fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Constants.cPink,
                                                  ),
                                                ),
                                                //  new Divider(height: 15.0,color: Colors.red,),
                                              ],
                                            )
                                          ],
                                        ),
                                        new Spacer(flex: 1),
                                        new IconButton(
                                          icon: Icon(Icons.delete, color: Colors.grey,),
                                          onPressed: () => referenceDatabase.child('${widget.storeId}').child('BeverageList').child('${snapshot.key}').remove(),
                                        ),

                                      ],
                                    ),
                                  );
                                }
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                //end Tab 1, Beverages

                //Tab 2, Others/Extras
                SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                        child: Column(
                          children: <Widget>[

                            SizedBox(height: 10,),
                            SizedBox(
                                child: Container(
                                  width: size.width*.7,
                                  height: size.height*0.045,
                                  child: TextField(
                                    controller:  extraName ,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                        EdgeInsets.all(15),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Constants.cPink),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        hintText: "Extra Name",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 8,),
                            SizedBox(
                                child: Container(
                                  width: size.width*.7,
                                  height: size.height*0.045,
                                  child: TextField(
                                    controller:  extraPrice ,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                        EdgeInsets.all(15),
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
                                          fontSize: 16,
                                        )
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 8,),
                            SizedBox(
                                child: Container(
                                  width: size.width*.7,
                                  height: size.height*0.045,
                                  child: TextField(
                                    controller:  extraDescription ,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                        EdgeInsets.all(15),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Constants.cPink),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        hintText: "Description",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 10,),
                            SizedBox(
                              child: Container(
                                width: size.width*.5,
                                //height: size.height*.05,
                                child: TextButton(
                                  onPressed: (){

                                    if (extraName.text=="" || extraPrice.text=="" || extraDescription.text=="")
                                    {
                                      Fluttertoast.showToast(msg: "Please fill the form.",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                      );
                                    }
                                    else{
                                      referenceDatabase
                                          .child('${widget.storeId}')
                                          .child('ExtrasList')
                                          .child('${extraName.text}')
                                          .update({'Name':extraName.text,'Description':extraDescription.text,'Price':extraPrice.text})
                                          .asStream();

                                      extraDescription.clear();
                                      extraName.clear();
                                      extraPrice.clear();
                                    }

                                  },
                                  child: Text(
                                    'Add Menu',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.cPink
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
                                query: referenceDatabase.child('${widget.storeId}').child('ExtrasList'),
                                itemBuilder: (BuildContext context,
                                    DataSnapshot snapshot,
                                    Animation<double> animation,
                                    int index)
                                {
                                  return  Card(
                                    child: Row(
                                      children:<Widget> [

                                        new Container(
                                          width: 100,
                                          height: 80,
                                          child: FittedBox(
                                            fit:BoxFit.fill,
                                            child: Image.asset("assets/images/pizza.png"),
                                          ),
                                        ),

                                        Container(  //Divider
                                          height: 50.0,
                                          width: 1.0,
                                          color: Colors.black54,
                                          margin: const EdgeInsets.only(left:0, right: 10.0),
                                        ),
                                        new Column(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Column (
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Container (
                                                    child: new Text('${snapshot.value['Name']}'' : ''${snapshot.value['Price']}',
                                                      style: TextStyle(  fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Constants.cPink
                                                      ),
                                                    )
                                                ),
                                                new Container(height: 5.0,),
                                                new Text('${snapshot.value['Description']}',
                                                  style: TextStyle(  fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Constants.cPink,
                                                  ),
                                                ),
                                                //  new Divider(height: 15.0,color: Colors.red,),
                                              ],
                                            )
                                          ],
                                        ),
                                        new Spacer(flex: 1),
                                        new IconButton(
                                          icon: Icon(Icons.delete, color: Colors.grey,),
                                          onPressed: () => referenceDatabase.child('${widget.storeId}').child('ExtrasList').child('${snapshot.key}').remove(),
                                        ),

                                      ],
                                    ),
                                  );
                                }
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                //end Tab 2, Others/Extras

              ],
            )

        )
    );
  }




}