import 'package:eatnywhere/custom%20widgets/order_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:eatnywhere/custom widgets/menu_list.dart';
import 'package:google_fonts/google_fonts.dart';


class CartPage extends StatefulWidget{

  final String storeId;

  CartPage (this.storeId, {Key? key}): super (key: key);

  @override
  _CartPage createState() => _CartPage();

}

class _CartPage extends State <CartPage> {

  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');
  final cartReferenceDatabase = FirebaseDatabase.instance.reference().child('EatnywhereOrders');

  final menuName = TextEditingController();
  final menuPrice = TextEditingController();

  late Map<dynamic, dynamic> _mapVal;
  late String storeName="";


  String dateToday = DateTime.now().toString().substring(0,10);

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
    storeName = _mapVal['StoreName'];
    return storeName;
  });


  Future<bool> _willPopCallback() async {
    //cartReferenceDatabase.child(dateToday).child('${user!.uid}').child('${widget.storeId}').remove();
    //print("Cart Cleared");
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
              headerSliverBuilder: (context, value){
                return [
                  SliverAppBar(
                    backgroundColor: Constants.cPrimaryColor,
                    stretch: true,
                    pinned: true,
                    expandedHeight: 180,
                    elevation: 1,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Container(
                          width: 120,
                          height: 150,
                          padding: EdgeInsets.all(0),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Icon(Icons.view_list_sharp,color: Colors.white,),
                          )
                      ),
                      centerTitle: true,
                      titlePadding: EdgeInsets.only(bottom:0,top: 30),
                      stretchModes: [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                        StretchMode.fadeTitle
                      ],
                      // background: _mapVal.isEmpty?CircularProgressIndicator():Image.asset("assets/images/eatnywhere-cover.png"),
                    ),
                    bottom: PreferredSize(preferredSize: Size.fromHeight(50),
                      child: Container(
                        width: 200,height: 35, padding: EdgeInsets.only(top:5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                          color: Constants.cFontPink.withOpacity(.8),
                        ),
                        child: Text('${_mapVal['StoreName']} | Order List',textAlign: TextAlign.center, style: GoogleFonts.signika(color: Constants.cPink,fontSize: 24,fontWeight: FontWeight.w100)),
                      ),
                    ),
                  ),
                ];
              },
              body: SafeArea(
                child: Center(
                  child: Column(
                    children: [

                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text("${user!.displayName},",
                              style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w200),
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text("Ready to grab your",
                              style: GoogleFonts.signika(color: Constants.cPink,fontSize: 30,fontWeight: FontWeight.w500),
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text("delicious meal?",
                              style: GoogleFonts.signika(color: Constants.cPink,fontSize: 45,fontWeight: FontWeight.w600),
                            ),
                          )
                      ),

                      OrderList(storeId: widget.storeId,),


                    ],

                  ),
                )
              )
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            Spacer(),
            ElevatedButton.icon(
              onPressed: (){

              },
              icon: Icon(Icons.cancel_sharp,color: Constants.cPink,),
              label: Text('Clear Cart',style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w400),),
              style: ElevatedButton.styleFrom(
                primary: Constants.cLightGreen,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
            Spacer(flex: 1,),
            ElevatedButton.icon(
              onPressed: (){

              },
              icon: Icon(Icons.payment,color: Constants.cPink,),
              label: Text('Place Order',style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w400),),
              style: ElevatedButton.styleFrom(
                primary: Constants.cLightGreen,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
            Spacer()
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      )
  );
}

