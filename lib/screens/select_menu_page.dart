import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:eatnywhere/custom widgets/custom_card.dart';

class SelectMenuPage extends StatefulWidget{

  final String storeId;
  SelectMenuPage (this.storeId, {Key? key}): super (key: key);

  @override
  _SelectMenuPage createState() => _SelectMenuPage();

}

class _SelectMenuPage extends State <SelectMenuPage> {

  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');

  final menuName = TextEditingController();
  final menuPrice = TextEditingController();

  late Map<dynamic, dynamic> _mapVal;
  late String storeName="";

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
    //Size size = MediaQuery.of(context).size;
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
                    child: Text('Select Menu - ${storeName.toUpperCase()}'),
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
                labelPadding: EdgeInsets.only(top:1, bottom: 1),
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
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
                            FirebaseAnimatedList(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                query: referenceDatabase.child('${widget.storeId}').child('MenuList'),
                                itemBuilder: (BuildContext context,
                                    DataSnapshot snapshot,
                                    Animation<double> animation,
                                    int index){
                                      return  new CustomCard(itemName: '${snapshot.key}'
                                                ' : '
                                                '${snapshot.value}',

                                          itemDescription: "The right kind of buns.",
                                          trailingIconOne: new Icon(Icons.remove, color: Colors.blueAccent,),
                                          trailingIconTwo: new Icon(Icons.add, color: Colors.blueAccent,),
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
                            FirebaseAnimatedList(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                query: referenceDatabase.child('${widget.storeId}').child('BeverageList'),
                                itemBuilder: (BuildContext context,
                                    DataSnapshot snapshot,
                                    Animation<double> animation,
                                    int index){
                                      return  new CustomCard(itemName: '${snapshot.key}'
                                          ' : '
                                          '${snapshot.value}',

                                        itemDescription: "The best in town!",
                                        trailingIconOne: new Icon(Icons.remove, color: Colors.blueAccent,),
                                        trailingIconTwo: new Icon(Icons.add, color: Colors.blueAccent,),
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
                            FirebaseAnimatedList(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                query: referenceDatabase.child('${widget.storeId}').child('ExtrasList'),
                                itemBuilder: (BuildContext context,
                                    DataSnapshot snapshot,
                                    Animation<double> animation,
                                    int index){
                                      return  new CustomCard(itemName: '${snapshot.key}'
                                          ' : '
                                          '${snapshot.value}',

                                        itemDescription: "The best in town!",
                                        trailingIconOne: new Icon(Icons.remove, color: Colors.blueAccent,),
                                        trailingIconTwo: new Icon(Icons.add, color: Colors.blueAccent,),
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

