import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/custom widgets/custom_card.dart';

class MenuList extends StatefulWidget {

  String storeId;
  MenuList({required this.storeId});

  @override
  State<StatefulWidget> createState() => _MenuList();
}

class _MenuList extends State<MenuList> with AutomaticKeepAliveClientMixin{

  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');

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
                   query: referenceDatabase.child('${widget.storeId}').child('MenuList'),
                   itemBuilder: (BuildContext context,
                       DataSnapshot snapshot,
                       Animation<double> animation,
                       int index){
                     return  new CustomCard(
                       storeId: widget.storeId,
                       itemName: '${snapshot.value['Name']}',
                       itemPrice: snapshot.value['Price'],
                       itemDescription: "${snapshot.value['Description']}",
                       itemUrl: "${snapshot.value['MenuUrl']}",
                       itemQty: 0,
                       trailingIconOne: new Icon(Icons.remove, color: Colors.blueAccent,),
                       trailingIconTwo: new Icon(Icons.add, color: Colors.blueAccent,),
                     );
                   }
               ),

               FirebaseAnimatedList(
                   physics: NeverScrollableScrollPhysics(),
                   shrinkWrap: true,
                   query: referenceDatabase.child('${widget.storeId}').child('BeverageList'),
                   itemBuilder: (BuildContext context,
                       DataSnapshot snapshot,
                       Animation<double> animation,
                       int index){
                     return  new CustomCard(
                       storeId: widget.storeId,
                       itemName: '${snapshot.value['Name']}',
                       itemPrice: snapshot.value['Price'],
                       itemDescription: "${snapshot.value['Description']}",
                       itemUrl: "${snapshot.value['MenuUrl']}",
                       itemQty: 0,
                       trailingIconOne: new Icon(Icons.remove, color: Colors.blueAccent,),
                       trailingIconTwo: new Icon(Icons.add, color: Colors.blueAccent,),
                     );
                   }
               ),

               FirebaseAnimatedList(
                   physics: NeverScrollableScrollPhysics(),
                   shrinkWrap: true,
                   query: referenceDatabase.child('${widget.storeId}').child('ExtrasList'),
                   itemBuilder: (BuildContext context,
                       DataSnapshot snapshot,
                       Animation<double> animation,
                       int index){
                     return  new CustomCard(
                       storeId: widget.storeId,
                       itemName: '${snapshot.value['Name']}',
                       itemPrice: snapshot.value['Price'],
                       itemDescription: "${snapshot.value['Description']}",
                       itemUrl: "${snapshot.value['MenuUrl']}",
                       itemQty: 0,
                       trailingIconOne: new Icon(Icons.remove, color: Colors.blueAccent,),
                       trailingIconTwo: new Icon(Icons.add, color: Colors.blueAccent,),
                     );
                   }
               ),
               SizedBox(height: 80,)

             ],
           )
       ),
     ),
   );
  }


}