import 'package:eatnywhere/custom%20widgets/beverage_list.dart';
import 'package:eatnywhere/custom%20widgets/extras_list.dart';
import 'package:eatnywhere/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:eatnywhere/custom widgets/menu_list.dart';
import 'package:eatnywhere/custom widgets/beverage_list.dart';
import 'package:eatnywhere/custom widgets/extras_list.dart';
import 'package:google_fonts/google_fonts.dart';


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
  Widget build(BuildContext context) => Scaffold(
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, value){
              return [
                SliverAppBar(
                    backgroundColor: Constants.cPrimaryColor,
                    stretch: true,
                    pinned: false,
                    expandedHeight: 250,
                    elevation: 1,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Container(
                        width: 120,
                        height: 150,
                        padding: EdgeInsets.all(1),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage("${_mapVal['StorePhoto']}"),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      centerTitle: true,
                      titlePadding: EdgeInsets.only(bottom: 30),
                      stretchModes: [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                        StretchMode.fadeTitle,
                      ],
                      //background: _mapVal.isEmpty?CircularProgressIndicator():Image.network("${_mapVal['StorePhoto']}",fit: BoxFit.cover,),
                    ),
                    bottom: TabBar(
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50), // Creates border
                          color: Constants.cLightGreen),
                      labelColor: Constants.cPink,
                      unselectedLabelColor: Colors.grey,
                      labelStyle:GoogleFonts.signika(color: Constants.cPink,fontSize: 16,fontWeight: FontWeight.w400),
                      tabs: [
                        Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 15,
                                ),
                                Text(" | Menu"),
                              ],
                            )
                        ),
                        Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.emoji_food_beverage,
                                  size: 15,
                                ),
                                Text(" | Beverages"),
                              ],
                            )
                        ),
                        Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.post_add_sharp,
                                  size: 15,
                                ),
                                Text(" | Extra"),
                              ],
                            )
                        ),
                      ],
                    )
                ),
              ];
            },
              body: TabBarView(
                children: [
                  MenuList(storeId: widget.storeId,),
                  BeverageList(storeId: widget.storeId),
                  ExtrasList(storeId: widget.storeId)
                ],
              ),
          ),
        )
      );
}

