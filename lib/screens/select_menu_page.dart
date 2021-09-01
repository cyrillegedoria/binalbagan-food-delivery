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
                    pinned: true,
                    expandedHeight: 400,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('${storeName.toUpperCase()}', style: GoogleFonts.signika(color: Constants.cPink,fontSize: 26,fontWeight: FontWeight.w600),),
                      centerTitle: true,
                      titlePadding: EdgeInsets.only(bottom: 100),
                      stretchModes: [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                        StretchMode.fadeTitle,
                      ],
                      background: Image.network("${_mapVal['StorePhoto']}",
                                  fit: BoxFit.cover,),
                    ),
                    bottom: TabBar(
                      indicatorColor: Constants.cPink,
                      indicatorWeight: 3.0,
                      labelColor: Constants.cPink,
                      labelPadding: EdgeInsets.only(top:1, bottom: 1),
                      unselectedLabelColor: Colors.grey,
                      labelStyle:GoogleFonts.signika(color: Constants.cPink,fontSize: 20,fontWeight: FontWeight.w300),
                      unselectedLabelStyle:GoogleFonts.signika(color: Constants.cPink,fontSize: 16,fontWeight: FontWeight.w100),
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

