import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddMenuPage extends StatefulWidget{

  final String storeId;
    AddMenuPage (this.storeId, {Key? key}): super (key: key);

  late bool isLoading = false;


@override
  _AddMenuPage createState() => _AddMenuPage();


}

class _AddMenuPage extends State <AddMenuPage>{

  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');

  final menuName = TextEditingController();
  final menuPrice = TextEditingController();
  final menuDescription = TextEditingController();
  final menuUrlTf = TextEditingController();

  final beverageName = TextEditingController();
  final beveragePrice = TextEditingController();
  final beverageDescription = TextEditingController();
  final beverageUrl = TextEditingController();

  final extraName = TextEditingController();
  final extraPrice = TextEditingController();
  final extraDescription = TextEditingController();
  final extraUrl = TextEditingController();

  late Map<dynamic, dynamic> _mapVal;
  late String storeName="";
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );


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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    // TODO: implement build
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
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
              titlePadding: EdgeInsets.only(bottom:30),
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
        //Tab 0, Main
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
                child: Column(
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: Icon(Icons.post_add,color: Constants.cPink,),
                      label: Text("Add Item",
                      style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w400),),
                      style: ElevatedButton.styleFrom(
                        primary: Constants.cLightGreen,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                     builder: (context, setState){

                                       return AlertDialog(
                                         scrollable: true,
                                         title: Text('New Menu',
                                           style: GoogleFonts.signika(color: Constants.cPink,fontSize: 22,fontWeight: FontWeight.w400),),
                                         content: Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Form(
                                             child: Column(
                                               children: <Widget>[
                                                 SizedBox(
                                                   child: Container(
                                                     width: size.width*.3,
                                                     height: size.height*.15,
                                                     decoration: new BoxDecoration(
                                                       color: Colors.white,
                                                       shape: BoxShape.circle,
                                                     ),
                                                     child: TextButton(
                                                       style: ElevatedButton.styleFrom(
                                                         shape: CircleBorder(),
                                                         padding: EdgeInsets.all(2),
                                                       ),
                                                       onPressed: (){
                                                         setState(() {
                                                           widget.isLoading = true;
                                                         });
                                                         PickImage()._onImageButtonPressed(ImageSource.gallery, context: context).then((value) => setState((){menuUrlTf.text=value;widget.isLoading=false;}));
                                                       },
                                                       child: menuUrlTf.text.isEmpty?Icon(Icons.restaurant_menu, size: 100):FittedBox(child: CircleAvatar(backgroundImage: NetworkImage('${menuUrlTf.text}'),backgroundColor: Colors.white,maxRadius: 60,), fit: BoxFit.fitWidth,),
                                                     ),
                                                   ),
                                                 ),
                                                 TextFormField(
                                                   controller: menuName,
                                                   decoration: InputDecoration(
                                                     labelStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w300),
                                                     labelText: "Menu Name",
                                                     filled: true,
                                                     fillColor: Colors.white,
                                                     contentPadding:
                                                     EdgeInsets.all(15),
                                                     focusedBorder: OutlineInputBorder(
                                                       borderSide: BorderSide(color: Constants.cPink),
                                                       borderRadius: BorderRadius.circular(16),
                                                     ),
                                                     enabledBorder: UnderlineInputBorder(
                                                       borderSide: BorderSide(color: Constants.cPink),
                                                       borderRadius: BorderRadius.circular(16),
                                                     ),
                                                   ),
                                                 ),
                                                 Container(height: 10,),
                                                 TextFormField(
                                                   controller: menuPrice,
                                                   keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                   inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                                                   decoration: InputDecoration(
                                                     labelStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w300),
                                                     labelText: "Price",
                                                     filled: true,
                                                     fillColor: Colors.white,
                                                     contentPadding:
                                                     EdgeInsets.all(15),
                                                     focusedBorder: OutlineInputBorder(
                                                       borderSide: BorderSide(color: Constants.cPink),
                                                       borderRadius: BorderRadius.circular(16),
                                                     ),
                                                     enabledBorder: UnderlineInputBorder(
                                                       borderSide: BorderSide(color: Constants.cPink),
                                                       borderRadius: BorderRadius.circular(16),
                                                     ),
                                                   ),
                                                 ),
                                                 Container(height: 10,),
                                                 TextFormField(
                                                   controller: menuDescription,
                                                   maxLength: 40,
                                                   decoration: InputDecoration(
                                                     labelStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w300),
                                                     labelText: "Description",
                                                     filled: true,
                                                     fillColor: Colors.white,
                                                     contentPadding:
                                                     EdgeInsets.all(15),
                                                     focusedBorder: OutlineInputBorder(
                                                       borderSide: BorderSide(color: Constants.cPink),
                                                       borderRadius: BorderRadius.circular(16),
                                                     ),
                                                     enabledBorder: UnderlineInputBorder(
                                                       borderSide: BorderSide(color: Constants.cPink),
                                                       borderRadius: BorderRadius.circular(16),
                                                     ),
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ),
                                         actions: [
                                           widget.isLoading==false?
                                           TextButton(
                                               child: Text("Submit",
                                                 style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w400),
                                               ),
                                               style: ButtonStyle(
                                                   backgroundColor: MaterialStateProperty.all<Color>(Constants.cLightGreen),
                                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                       RoundedRectangleBorder(
                                                         borderRadius: BorderRadius.circular(16.0),
                                                       )
                                                   )
                                               ),
                                               onPressed: () {
                                                 if (menuName.text=="" || menuPrice.text=="" || menuDescription.text=="")
                                                 {
                                                   Fluttertoast.showToast(msg: "Please fill the form.",
                                                     toastLength: Toast.LENGTH_LONG,
                                                     gravity: ToastGravity.TOP,
                                                   );
                                                 }
                                                 else{
                                                   referenceDatabase
                                                       .child('${widget.storeId}')
                                                       .child('MenuList')
                                                       .child('${menuName.text}')
                                                       .update({'Name':menuName.text,'Description':menuDescription.text,'Price':menuPrice.text,'MenuUrl':menuUrlTf.text})
                                                       .asStream();

                                                   menuDescription.clear();
                                                   menuName.clear();
                                                   menuPrice.clear();
                                                   menuUrlTf.clear();
                                                   Navigator.pop(context);
                                                 }

                                               }
                                           )
                                               :CircularProgressIndicator(color: Constants.cLightGreen,)
                                         ],
                                       );
                                  },
                              );
                            },
                         );
                      }, //onPressed
                    ),

                    FirebaseAnimatedList(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        query: referenceDatabase.child('${widget.storeId}').child('MenuList'),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index)
                        {
                          return  Card(
                            child: Row(
                              children:<Widget> [

                                new Container(
                                  width: 64,
                                  height: 80,
                                  padding: EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage('${snapshot.value['MenuUrl'].toString()}'),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                new Container(width: 10,),
                                new Container(  //Divider
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
                                            child: new Text('${snapshot.value['Name']}'' : ''${snapshot.value['Price']}',
                                              style: TextStyle(  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Constants.cPink
                                              ),
                                            )
                                        ),
                                        new Container(height: 5.0,),
                                        new Text('${snapshot.value['Description']}',
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
                                new Spacer(flex: 1),
                                new IconButton(
                                  icon: Icon(Icons.delete, color: Colors.grey,),
                                  onPressed: () => referenceDatabase.child('${widget.storeId}').child('MenuList').child('${snapshot.key}').remove(),
                                ),

                              ],
                            ),
                          );
                        }
                    ),
                  ],
                )
            ),
          ),
        ),
        //end Tab 0, Main

        //Tab 1, Beverages
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
                child: Column(
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: Icon(Icons.post_add,color: Constants.cPink,),
                      label: Text("Add Item",
                        style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w400),),
                      style: ElevatedButton.styleFrom(
                        primary: Constants.cLightGreen,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState){

                                return AlertDialog(
                                  scrollable: true,
                                  title: Text('New Menu',
                                    style: GoogleFonts.signika(color: Constants.cPink,fontSize: 22,fontWeight: FontWeight.w400),),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Form(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            child: Container(
                                              width: size.width*.3,
                                              height: size.height*.15,
                                              decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: TextButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  padding: EdgeInsets.all(2),
                                                ),
                                                onPressed: (){
                                                  setState(() {
                                                    widget.isLoading = true;
                                                  });
                                                  PickImage()._onImageButtonPressed(ImageSource.gallery, context: context).then((value) => setState((){beverageUrl.text=value;widget.isLoading=false;}));
                                                },
                                                child: beverageUrl.text.isEmpty?Icon(Icons.emoji_food_beverage_sharp, size: 100):FittedBox(child: CircleAvatar(backgroundImage: NetworkImage('${beverageUrl.text}'),backgroundColor: Colors.white,maxRadius: 60,), fit: BoxFit.fitWidth,),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: beverageName,
                                            decoration: InputDecoration(
                                              labelStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w300),
                                              labelText: "Menu Name",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                              EdgeInsets.all(15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                          Container(height: 10,),
                                          TextFormField(
                                            controller: beveragePrice,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                                            decoration: InputDecoration(
                                              labelStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w300),
                                              labelText: "Price",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                              EdgeInsets.all(15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                          Container(height: 10,),
                                          TextFormField(
                                            controller: beverageDescription,
                                            maxLength: 40,
                                            decoration: InputDecoration(
                                              labelStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w300),
                                              labelText: "Description",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                              EdgeInsets.all(15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    widget.isLoading==false?
                                    TextButton(
                                        child: Text("Submit",
                                          style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w400),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Constants.cLightGreen),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16.0),
                                                )
                                            )
                                        ),
                                        onPressed: () {
                                          if (beverageName.text=="" || beveragePrice.text=="" || beverageDescription.text=="")
                                          {
                                            Fluttertoast.showToast(msg: "Please fill the form.",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.TOP,
                                            );
                                          }
                                          else{
                                            referenceDatabase
                                                .child('${widget.storeId}')
                                                .child('BeverageList')
                                                .child('${beverageName.text}')
                                                .update({'Name':beverageName.text,'Description':beverageDescription.text,'Price':beveragePrice.text,'MenuUrl':beverageUrl.text})
                                                .asStream();

                                            beverageDescription.clear();
                                            beverageName.clear();
                                            beveragePrice.clear();
                                            beverageUrl.clear();
                                            Navigator.pop(context);
                                          }

                                        }
                                    )
                                        :CircularProgressIndicator(color: Constants.cLightGreen,)
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }, //onPressed
                    ),

                    FirebaseAnimatedList(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        query: referenceDatabase.child('${widget.storeId}').child('BeverageList'),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index)
                        {
                          return  Card(
                            child: Row(
                              children:<Widget> [

                                new Container(
                                  width: 64,
                                  height: 80,
                                  padding: EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage('${snapshot.value['MenuUrl'].toString()}'),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                new Container(width: 10,),
                                new Container(  //Divider
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
                                            child: new Text('${snapshot.value['Name']}'' : ''${snapshot.value['Price']}',
                                              style: TextStyle(  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Constants.cPink
                                              ),
                                            )
                                        ),
                                        new Container(height: 5.0,),
                                        new Text('${snapshot.value['Description']}',
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
                                new Spacer(flex: 1),
                                new IconButton(
                                  icon: Icon(Icons.delete, color: Colors.grey,),
                                  onPressed: () => referenceDatabase.child('${widget.storeId}').child('BeverageList').child('${snapshot.key}').remove(),
                                ),

                              ],
                            ),
                          );
                        }
                    ),
                  ],
                )
            ),
          ),
        ),
        //end Tab 1, Beverages

        //Tab 2, Others/Extras
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
                child: Column(
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: Icon(Icons.post_add,color: Constants.cPink,),
                      label: Text("Add Item",
                        style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w400),),
                      style: ElevatedButton.styleFrom(
                        primary: Constants.cLightGreen,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState){

                                return AlertDialog(
                                  scrollable: true,
                                  title: Text('New Menu',
                                    style: GoogleFonts.signika(color: Constants.cPink,fontSize: 22,fontWeight: FontWeight.w400),),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Form(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            child: Container(
                                              width: size.width*.3,
                                              height: size.height*.15,
                                              decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: TextButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  padding: EdgeInsets.all(2),
                                                ),
                                                onPressed: (){
                                                  setState(() {
                                                    widget.isLoading = true;
                                                  });
                                                  PickImage()._onImageButtonPressed(ImageSource.gallery, context: context).then((value) => setState((){extraUrl.text=value;widget.isLoading=false;}));
                                                },
                                                child: extraName.text.isEmpty?Icon(Icons.post_add_sharp, size: 100):FittedBox(child: CircleAvatar(backgroundImage: NetworkImage('${extraUrl.text}'),backgroundColor: Colors.white,maxRadius: 60,), fit: BoxFit.fitWidth,),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: extraName,
                                            decoration: InputDecoration(
                                              labelStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w300),
                                              labelText: "Menu Name",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                              EdgeInsets.all(15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                          Container(height: 10,),
                                          TextFormField(
                                            controller: extraPrice,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                                            decoration: InputDecoration(
                                              labelStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w300),
                                              labelText: "Price",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                              EdgeInsets.all(15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                          Container(height: 10,),
                                          TextFormField(
                                            controller: extraDescription,
                                            maxLength: 40,
                                            decoration: InputDecoration(
                                              labelStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w300),
                                              labelText: "Description",
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                              EdgeInsets.all(15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Constants.cPink),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    widget.isLoading==false?
                                    TextButton(
                                        child: Text("Submit",
                                          style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w400),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Constants.cLightGreen),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16.0),
                                                )
                                            )
                                        ),
                                        onPressed: () {
                                          if (extraName.text=="" || extraPrice.text=="" || extraDescription.text=="")
                                          {
                                            Fluttertoast.showToast(msg: "Please fill the form.",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.TOP,
                                            );
                                          }
                                          else{
                                            referenceDatabase
                                                .child('${widget.storeId}')
                                                .child('ExtrasList')
                                                .child('${extraName.text}')
                                                .update({'Name':extraName.text,'Description':extraDescription.text,'Price':extraPrice.text,'MenuUrl':extraUrl.text})
                                                .asStream();

                                            extraPrice.clear();
                                            extraName.clear();
                                            extraDescription.clear();
                                            extraUrl.clear();
                                            Navigator.pop(context);
                                          }

                                        }
                                    )
                                        :CircularProgressIndicator(color: Constants.cLightGreen,)
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }, //onPressed
                    ),

                    FirebaseAnimatedList(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        query: referenceDatabase.child('${widget.storeId}').child('ExtrasList'),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index)
                        {
                          return  Card(
                            child: Row(
                              children:<Widget> [

                                new Container(
                                  width: 64,
                                  height: 80,
                                  padding: EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage('${snapshot.value['MenuUrl'].toString()}'),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                new Container(width: 10,),
                                new Container(  //Divider
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
                                            child: new Text('${snapshot.value['Name']}'' : ''${snapshot.value['Price']}',
                                              style: TextStyle(  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Constants.cPink
                                              ),
                                            )
                                        ),
                                        new Container(height: 5.0,),
                                        new Text('${snapshot.value['Description']}',
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
                                new Spacer(flex: 1),
                                new IconButton(
                                  icon: Icon(Icons.delete, color: Colors.grey,),
                                  onPressed: () => referenceDatabase.child('${widget.storeId}').child('ExtrasList').child('${snapshot.key}').remove(),
                                ),

                              ],
                            ),
                          );
                        }
                    ),
                  ],
                )
            ),
          ),
        ),
        //end Tab 2, Others/Extras

          ],

        ),
      ),
       )
    )

    );

  }


}

class PickImage {

  late File _image;
  late String url;

  Future  _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    final pickedFile =  await ImagePicker().pickImage(source:source,imageQuality: 40,maxHeight: 720, maxWidth: 720);
    _image = File(pickedFile!.path);


    String filename = pickedFile.path.split('/').last;
    Reference storageReference = FirebaseStorage.instance.ref("menu photo/$filename");
    final UploadTask uploadTask = storageReference.putFile(_image);
    final TaskSnapshot downloadUrl = (await uploadTask);
    url = await downloadUrl.ref.getDownloadURL();
    //print("Check Path xxx - $url");
    return url;
  }




}