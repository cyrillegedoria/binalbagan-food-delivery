import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';

class CustomCard extends StatefulWidget {
  String itemName;
  String itemDescription;
  Icon trailingIconOne;
  Icon trailingIconTwo;

  CustomCard({required this.itemName, required this.itemDescription, required this.trailingIconOne, required this.trailingIconTwo});

  @override
  _CustomCardState createState() => _CustomCardState();

}


class _CustomCardState extends State<CustomCard>{

  late int itemQty=0  ;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Card(
        child: new Row(
          children: <Widget> [
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
                        child: new Text(widget.itemName,
                          style: TextStyle(  fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Constants.cPink
                          ),
                        )
                    ),
                    new Container(height: 5.0,),
                    new Text(widget.itemDescription,
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
            Spacer(flex: 1,),
            new Column(
              children: [
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new IconButton(icon: widget.trailingIconOne,iconSize: 20,
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
                    new IconButton(icon: widget.trailingIconTwo,iconSize: 20,
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
                        fontSize: 16,
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
                )
              ],
            )
          ],
        )
    );
  }

}
