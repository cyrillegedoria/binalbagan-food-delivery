import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:eatnywhere/custom widgets/menu_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_state/gs.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cart_page.dart';


class SelectMenuPage extends StatefulWidget with StatefulGS{

  final String storeId;
  SelectMenuPage (this.storeId, {Key? key}): super (key: key);

  @override
  _SelectMenuPage createState() => _SelectMenuPage();

}

class _SelectMenuPage extends State <SelectMenuPage> {

  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');
  final cartReferenceDatabase = FirebaseDatabase.instance.reference().child('EatnywhereOrders');

  final menuName = TextEditingController();
  final menuPrice = TextEditingController();

  late Map<dynamic, dynamic> _mapVal;
  late String storeName="";
  late String storeUrl="https://firebasestorage.googleapis.com/v0/b/eat-anywhere-7db46.appspot.com/o/eatnywhere%2Featnywhere%20default%20logo.png?alt=media&token=0777ddb0-72d8-432e-a0cb-f7892550fc39";

  String dateToday = DateTime.now().toString().substring(0,10);

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gs[#totalItems]=0;
    gs[#totalPayment]=0;
    if (storeName==""){
      returnRef().then(
              (String i) => setState((){storeName=i;})
      );
    }
  }

  Future<String> returnRef () async => referenceDatabase.child('${widget.storeId}').once().then((snapshot){
    _mapVal = snapshot.value;
    storeName = _mapVal['StoreName'];
    storeUrl = _mapVal['StorePhoto'];
    return storeName;
  });


  Future<bool> _willPopCallback() async {
    cartReferenceDatabase.child(dateToday).child('${user!.uid}').remove();
    gs[#totalItems]=0;
    gs[#totalPayment]=0;
    print("Cart Cleared");
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
                    expandedHeight: 235,
                    elevation: 1,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Container(
                        width: 120,
                        height: 150,
                        padding: EdgeInsets.all(0),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(storeUrl),
                            backgroundColor: Colors.white,
                          ),
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
                    width: MediaQuery.of(context).size.width*.9,height: 40, padding: EdgeInsets.only(top:8),
                    decoration: BoxDecoration(
                     borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                      color: Constants.cLightBlue.withOpacity(.9),
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(storeName,textAlign: TextAlign.center, style: GoogleFonts.signika(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w500)),

                      Spacer(flex: 3,),
                      //Ratings

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('12am-12pm',textAlign: TextAlign.center, style: GoogleFonts.signika(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400)),

                            ],
                          ),

                          Icon(Icons.access_time,color: Colors.white, size: 14,),
                        ],
                      ),
                      SizedBox(width: 5,),
                      Container(height: 25.0, width: 1, color: Colors.white,),
                      SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('4.5',textAlign: TextAlign.center, style: GoogleFonts.signika(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400)),
                              SizedBox(width:1,),
                              Icon(Icons.star,color: Colors.yellowAccent, size: 14,),
                            ],
                          ),
                          Text('25 reviews',textAlign: TextAlign.center, style: GoogleFonts.signika(color: Colors.white,fontSize: 10,fontWeight: FontWeight.w100)),
                        ],
                      ),
                      SizedBox(width: 5,),
                      Container(height: 25.0, width: 1, color: Colors.white,),
                      SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('37',textAlign: TextAlign.center, style: GoogleFonts.signika(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400)),
                              SizedBox(width:1,),
                              Icon(Icons.favorite,color: Colors.redAccent, size: 14,),
                            ],
                          ),
                          Text('favorites',textAlign: TextAlign.center, style: GoogleFonts.signika(color: Colors.white,fontSize: 10,fontWeight: FontWeight.w100)),
                        ],
                      ),
                      // </>Ratings
                      Spacer(),

                    ],

                  )
                  ),
                  ),

                ),
              ];
            },
            body: SafeArea(
              child: MenuList(storeId: widget.storeId,),
            )
          ),
        ),
        floatingActionButton: ElevatedButton.icon(
          onPressed: (){

            if(gs[#totalItems]==0){
              Fluttertoast.showToast(
                msg: "Your cart is empty.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,

              );

            }
            else{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CartPage(storeId: widget.storeId)));

            }


          },
          icon: Icon(Icons.shopping_cart_sharp,color: Constants.cRed,),
          label: Text('View Cart (${gs[#totalItems]})',style: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w400),),
          style: ElevatedButton.styleFrom(
            primary: Constants.cLightOrange,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      )
  );
}

