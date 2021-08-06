import 'package:eatnywhere/screens/add_business_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:eatnywhere/services/firebase_service.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');


 /* void printDB (){
    referenceDatabase.once().then((DataSnapshot snapshot){
    Map<dynamic, dynamic> mapVal = snapshot.value;
      //print ('Data: ${mapVal.values.toList()[8]['Stores']['StoreName']}');
     // print (referenceDatabase.);

   });
  }*/

  int _storeCount = 0;
  late int _indexOfStores =0;
  late Map<dynamic, dynamic> _mapVal;
  @override
  void initState() {
    super.initState();
    if  (_storeCount == 0 )
      {
        returnIndex().then(
                (int i) => setState((){_storeCount=i;})
        );
      }

  }

  Future<int> returnIndex () async => referenceDatabase.once().then((snapshot){
    Map<dynamic, dynamic> mapVal;
    mapVal = snapshot.value;
    //print ('Data: ${mapVal.values.toList()[8]['Stores']['StoreName']}');
    //print('value is:${mapVal.length}');
    _storeCount = mapVal.length;
    _mapVal = snapshot.value;
    return _storeCount;
  });

  @override
  Widget build(BuildContext context) {

    final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');
    referenceDatabase.once().then((DataSnapshot snapshot) {
       _mapVal = snapshot.value;
    });

    /**
        return Scaffold(
        appBar: AppBar(

        actions: <Widget>[
        CircleAvatar(
        backgroundImage: NetworkImage(user!.photoURL!),
        radius: 20,
        ),

        IconButton(
        icon: Icon(
        Icons.logout,
        color: Colors.white,
        ),
        onPressed: () async {
        FirebaseService service = new FirebaseService();
        await service.signOutFromGoogle();
        Navigator.pushReplacementNamed(
        context, Constants.signInNavigate);
        },
        )

        ],

        ),
        body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Text(user!.email!),
        Text(user!.displayName!),
        CircleAvatar(
        backgroundImage: NetworkImage(user!.photoURL!),
        radius: 20,
        )
        ],
        )));
     **/

    /**return Column(
      children: [
        Column(
        children: [
            Container(
              child: Padding(
                  padding: EdgeInsets.all(0),
              child: AppBar(
                backgroundColor: Constants.kDarkBlueColor,
              title: Row(
                children: [
                    Container(
                    child: CircleAvatar(
                    backgroundImage: NetworkImage(user!.photoURL!),
                    radius: 20,
                    ),
                 ),
                    // Spacer(flex: 100,),
                    SizedBox(width: 10,),
                    Container(
                      child: Text(user!.displayName!),
                    ),
                    Spacer(flex: 100,),
                    IconButton(
                        icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                    ),
                        onPressed: () async {
                        FirebaseService service = new FirebaseService();
                        await service.signOutFromGoogle();
                        Navigator.pushReplacementNamed(
                        context, Constants.signInNavigate);
                    },
                    ),
                  ],
                 ),
              ),
            ),
           ),

        ],
    ),
     HomePageBody()
    ],
    );
    */

    return Scaffold(
      backgroundColor: Constants.cPrimaryColor,
      appBar: AppBar(
        backgroundColor: Constants.cPrimaryColor,
        title: Row(
         children: [
          Container(
           child: CircleAvatar(
             backgroundImage: NetworkImage(user!.photoURL!),
              radius: 20,
            ),
           ),
          // Spacer(flex: 100,),
           SizedBox(width: 10,),
           Container(
            child: Text(user!.displayName!),
           ),
           Spacer(flex: 10,),
           IconButton(
               onPressed: (){
                // Navigator.push(
                 //    context, Constants.addBusinessNavigate);
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => AddBusinessPage()));
               },
               icon: Icon(
                 Icons.add_business,
                 size: 35,
               )
           ),
           Spacer (flex: 1),
           IconButton(
              icon: Icon(
              Icons.logout,
              color: Constants.cPink,
                size: 35,
              ),
              onPressed: () async {
              FirebaseService service = new FirebaseService();
              await service.signOutFromGoogle();
              Navigator.pushReplacementNamed(
              context, Constants.welcomeNavigate);
                },
             ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
                children: <Widget>[
                  HomePageBody(),
                  GridView.count(
                      //physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      //dragStartBehavior: DragStartBehavior.start,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 0,
                        crossAxisCount: 2,
                        children: List.generate(_storeCount, (index){
                          _indexOfStores = index;
                          return new InkWell(
                            onTap: (){
                            },
                            child: SizedBox(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Constants.cLightGreen,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget> [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('${_mapVal.values.toList()[_indexOfStores]['StoreName']}',
                                        style: TextStyle(
                                          color: Constants.cPink,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("San Pedro, Binalbagan",
                                        style: TextStyle(
                                          color: Constants.cPink,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                    Spacer(flex: 1,),
                                    Container(
                                      child: FittedBox(
                                        fit:BoxFit.fill,
                                        child: Image.asset("assets/images/pizza.png"),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    ),

                ],
                )
            ),
          ),
        ),

    );
  }
}// End _HomePageState

//Restaurants
class HomePageBody extends StatelessWidget {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       SizedBox(height: 30 ,),
       SizedBox(
        width: size.width * .8,
          child: TextField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              contentPadding:
              EdgeInsets.all(20),
              //enabledBorder: border,
              //focusedBorder: border,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(22),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(22),
                ),
              suffixIcon: Padding(
                child: FaIcon(
                    FontAwesomeIcons.search,
                    size: 25,
                    color: Constants.cFontPink,
                  ),
                padding: EdgeInsets.only(top: 10, left: 10),
              ),
              hintText: "Search food & stores",
                hintStyle: TextStyle(
                  color: Constants.cFontPink,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                )
            ),
          ),
        ),
       SizedBox(height: 30),
       RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text:"Food Stores in Binalbagan",
                  style: TextStyle(
                    color: Constants.cPink,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )),
                  ]
              )
       ),
       SizedBox(height: 20,),
      ],
    );
  }
}// End HomePageBody
