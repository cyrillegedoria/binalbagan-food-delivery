import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/custom widgets/custom_card.dart';
import 'package:global_state/gs.dart';

class OrderList extends StatefulWidget with StatefulGS{

  String storeId;
  OrderList({required this.storeId});

  @override
  State<StatefulWidget> createState() => _OrderList();
}

class _OrderList extends State<OrderList> with AutomaticKeepAliveClientMixin{

  User? user = FirebaseAuth.instance.currentUser;
  final cartReferenceDatabase = FirebaseDatabase.instance.reference().child('EatnywhereOrders');

  String timeStamp = DateTime.now().toString().substring(0,19);
  String dateToday = DateTime.now().toString().substring(0,10);

  late double price=0;
  late int qty=0;
  late double totalPayment =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return SafeArea(
     child: SingleChildScrollView(
       child: Container(
           child: Column(
             children: <Widget>[

               FirebaseAnimatedList(
                   physics: NeverScrollableScrollPhysics(),
                   shrinkWrap: true,
                   query: cartReferenceDatabase.child(dateToday).child(user!.uid).child(widget.storeId),
                   itemBuilder: (BuildContext context,
                       DataSnapshot snapshot,
                       Animation<double> animation,
                       int index){

                       return new CustomCard(
                         storeId: widget.storeId,
                         itemName: '${snapshot.value['Name']}',
                         itemPrice: snapshot.value['Price'],
                         itemDescription: "${snapshot.value['Description']}",
                         itemUrl: "${snapshot.value['MenuUrl']}",
                         itemQty: snapshot.value['Qty'] as int,
                         trailingIconOne: new Icon(
                           Icons.remove, color: Colors.blueAccent,),
                         trailingIconTwo: new Icon(
                           Icons.add, color: Colors.blueAccent,),
                       );



                   }
               ),


             ],
           )
       ),
     ),
   );

  }

}
