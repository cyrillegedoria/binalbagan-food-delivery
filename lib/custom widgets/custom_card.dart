import 'package:eatnywhere/screens/select_menu_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:global_state/gs.dart';
import 'package:global_state/transition.dart';

class CustomCard extends StatefulWidget with StatefulGS {
  String storeId;
  String itemName;
  String itemDescription;
  String itemPrice;
  String itemUrl;
  int itemQty;
  Icon trailingIconOne;
  Icon trailingIconTwo;

  CustomCard({
    required this.storeId,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemUrl,
    required this.itemQty,
    required this.trailingIconOne,
    required this.trailingIconTwo
  });

  @override
  _CustomCardState createState() => _CustomCardState();

}


class _CustomCardState extends State<CustomCard>{

  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference().child('EatnywhereOrders');
  late int itemQty=0;
  final String addToCartBtnTxt = "Add to Cart";
  final String updateBtnTxt = "Update";
  String timeStamp = DateTime.now().toString().substring(0,19);
  String dateToday = DateTime.now().toString().substring(0,10);

  late Map<dynamic, dynamic> _cartVal;
  late int cartItemCount = 0;

  late double price=0;
  late int qty=0;
  late double totalPayment=0;

  Future<int> cartCount () async => referenceDatabase.child(dateToday).child(user!.uid).child(widget.storeId).once().then((snapshot){
    try {
      _cartVal = snapshot.value;
      cartItemCount = _cartVal.length;

      gs[#totalItems]=cartItemCount;

     // print(_cartVal['Bihon']['Qty']);
      //print(_cartVal['Bihon']['Price']);

      for (var k in _cartVal.keys) {
        //print("Key : $k, Qty : ${_cartVal[k]['Qty']}");
        //print("Key : $k, Price : ${_cartVal[k]['Price']}");
        totalPayment = totalPayment + (_cartVal[k]['Qty']*double.parse(_cartVal[k]['Price']));
      }

      gs[#totalPayment] = totalPayment;
      totalPayment =0;
      referenceDatabase
          .child(dateToday)
          .child(user!.uid)
          .update({'NoOfItems': cartItemCount})
          .asStream();
    }
    catch(e){
      totalPayment =0;
      gs[#totalPayment] = totalPayment;
      gs[#totalItems]=0;
      referenceDatabase
          .child(dateToday)
          .child(user!.uid)
          .update({'NoOfItems': 0})
          .asStream();
    }
    return cartItemCount;
  });

  @override
  void initState() {
    // TODO: implement initState

    widget.itemQty==0?itemQty=0:itemQty=widget.itemQty;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return new Card(
      elevation: 2,
        child: new Row(
          children: <Widget> [
            new Container(width: 10,),
            new Container(
              width: 64,
              height: 80,
              padding: EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.itemUrl),
                backgroundColor: Colors.white,
              ),
            ),
            new Container(width: 10,),
            new Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container (
                        child: new Text('${widget.itemName}: ${widget.itemPrice}',
                            style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w200)
                        )
                    ),
                    new Container(height: 5.0,),
                    new Container(
                    child: new Text(widget.itemDescription,
                        style: GoogleFonts.signika(color: Constants.cPink,fontSize: 12,fontWeight: FontWeight.w100)
                    ),
                    )
                  ],
                )
              ],
            ),
            Spacer(flex: 1,),
            Container(  //Divider
              height: 35.0,
              width: .2,
              color: Colors.black54,
              margin: const EdgeInsets.only(left:0, right: 10.0),
            ),
            new Column(
              children: [
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new IconButton(icon: widget.trailingIconOne,iconSize: 18,
                        onPressed: () {
                          //deduct itemQty
                          if(itemQty>=1){
                            setState(() {
                              itemQty--;

                              referenceDatabase
                                  .child(dateToday)
                                  .child(user!.uid)
                                  .child(widget.storeId)
                                  .child(widget.itemName)
                                  .update(
                                  {'Name':widget.itemName,
                                    'Price':widget.itemPrice,
                                    'Description':widget.itemDescription,
                                    'MenuUrl':widget.itemUrl,
                                    'Qty':itemQty,
                                    'TimeStamp':timeStamp})
                                  .asStream();

                              itemQty==0?referenceDatabase.child(dateToday).child('${user!.uid}').child('${widget.storeId}').child('${widget.itemName}').remove():null;

                              cartCount();

                            });
                          }
                          else if(itemQty==0){
                            setState(() {
                              itemQty=0;
                            });
                          }
                        }),
                    new Container(
                      width: 15,
                      child: new Text('${itemQty.toString()}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    new IconButton(icon: widget.trailingIconTwo,iconSize: 18,
                        onPressed: () {
                          //add itemQty
                          if(itemQty<10){
                            setState(() {
                              itemQty++;

                            referenceDatabase
                                .child(dateToday)
                                .child(user!.uid)
                                .child(widget.storeId)
                                .child(widget.itemName)
                                .update(
                                {'Name':widget.itemName,
                                  'Price':widget.itemPrice,
                                  'Description':widget.itemDescription,
                                  'MenuUrl':widget.itemUrl,
                                  'Qty':itemQty,
                                  'TimeStamp':timeStamp})
                                .asStream();

                              cartCount();


                            });
                          }
                          else if(itemQty==10){
                            setState(() {itemQty=10;});
                          }
                        }),
                  ],
                ),
               /* TextButton(
                  onPressed: () {

                    referenceDatabase
                        .child(dateToday)
                        .child(user!.uid)
                        .child(widget.storeId)
                        .child(widget.itemName)
                        .update(
                        {'Name':widget.itemName,
                         'Price':widget.itemPrice,
                         'Description':widget.itemDescription,
                         'MenuUrl':widget.itemUrl,
                         'Qty':itemQty,
                         'TimeStamp':timeStamp})
                        .asStream();

                    Fluttertoast.showToast(msg: "Item added to cart!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                    );
                      setState(() {});
                  },
                  child: Text(
                      widget.itemQty==0?addToCartBtnTxt:updateBtnTxt,
                      style: GoogleFonts.signika(color: Constants.cPink,fontSize: 16,fontWeight: FontWeight.w100)
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Constants.cLightGreen),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )
                      )
                  ),
                )*/
              ],
            )
          ],
        )
    );
  }

}




