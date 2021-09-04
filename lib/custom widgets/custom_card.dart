import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';

class CustomCard extends StatefulWidget {
  String itemName;
  String itemDescription;
  String itemPrice;
  String itemUrl;
  Icon trailingIconOne;
  Icon trailingIconTwo;

  CustomCard({required this.itemName, required this.itemDescription, required this.itemPrice, required this.itemUrl, required this.trailingIconOne, required this.trailingIconTwo});

  @override
  _CustomCardState createState() => _CustomCardState();

}


class _CustomCardState extends State<CustomCard>{

  late int itemQty=0  ;

  @override
  Widget build(BuildContext context) {

    return new Card(
      elevation: 2,
        child: new Row(
          children: <Widget> [
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
                          style: TextStyle(  fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Constants.cPink
                          ),
                        )
                    ),
                    new Container(height: 5.0,),
                    new Container(
                    child: new Text(widget.itemDescription,
                      style: TextStyle(  fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Constants.cPink,
                      ),
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
                            setState(() {itemQty--;});
                          }
                          else if(itemQty==0){
                            setState(() {itemQty=0;});
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
                            setState(() {itemQty++;});
                          }
                          else if(itemQty==10){
                            setState(() {itemQty=10;});
                          }
                        }),
                  ],
                ),
                TextButton(
                  onPressed: () {  },
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Constants.cPink
                    ) ,
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Constants.cLightGreen),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )
                      )
                  ),
                )
              ],
            )
          ],
        )
    );
  }

}
