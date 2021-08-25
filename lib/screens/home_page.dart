import 'package:eatnywhere/screens/add_business_page.dart';
import 'package:eatnywhere/screens/select_menu_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:eatnywhere/services/firebase_service.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eatnywhere/services/sqflite_search_query.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';




class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

}


class _HomePageState extends State<HomePage> {

  User? user = FirebaseAuth.instance.currentUser;
  final searchTf = TextEditingController();


  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    CgDbHelper(); //Call sqflite_search_query to populate local database.
    //SearchDb().getStore("");
    super.initState();

    searchTf.addListener(_onSearchChanged);
  }

  @override
  void dispose(){
    searchTf.removeListener(_onSearchChanged);
    searchTf.dispose();
    super.dispose();
  }

  _onSearchChanged(){
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SearchDb searchDb = SearchDb();



    return Scaffold(
      backgroundColor: Constants.cPrimaryColor,
      appBar: AppBar(
        backgroundColor: Constants.cPrimaryColor,
        title: Row(
         children: [
          Container(
           child: CircleAvatar(
             backgroundImage: NetworkImage(user!.photoURL!),
              radius: 15,
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

                 Navigator.push(context,MaterialPageRoute(builder: (context) => AddBusinessPage()));

                 },
               icon: Icon(
                 Icons.add_business,
                 size: 30,
               )
           ),
           Spacer (flex: 1),
           IconButton(
              icon: Icon(
              Icons.logout,
              color: Constants.cPink,
                size: 30,
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
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30 ,),
                      SizedBox(
                        width: size.width * .8,
                        child: Container(
                            child: TextField(
                              controller: searchTf,
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
                            )
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Text("Food Stores in Binalbagan",
                          style: TextStyle(color: Constants.cPink,fontWeight: FontWeight.bold,fontSize: 24,),
                        ),
                      ),

                      SizedBox(height: 3,),
                    ],
                  ),

                  FutureBuilder<List<Store>>(

                    future: searchDb.getStore(searchTf.text),
                    builder: (context,AsyncSnapshot<List<Store>> snapshot){
                      if(!snapshot.hasData){
                        // print('ERROR xxxxx No Data!');
                        return CircularProgressIndicator();
                      }
                      //print('This is from snapshot.data ---- ${snapshot.data}');
                      return new ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {

                            return new InkWell(
                              onTap: (){

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectMenuPage('${snapshot.data![index].id}')));

                              },
                              child: new Container(
                                child: new Card(
                                  child: Row(

                                    children:<Widget> [
                                      new Container(
                                        width: 60,
                                        height: 80,
                                        margin: const EdgeInsets.only(left:15, right: 15.0),
                                        child: CircleAvatar(
                                          backgroundColor: Constants.cMint,
                                          child: new Text("${snapshot.data![index].storeName.toString()[0]}${snapshot.data![index].storeName.toString()[1]}",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,color: Colors.white),),
                                        ),
                                      ),
                                      new Container(  //Divider
                                        height: 60.0,
                                        width: .5,
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
                                                  child: new Text('${snapshot.data![index].storeName}',
                                                    style: TextStyle(  fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Constants.cPink
                                                    ),
                                                  )
                                              ),
                                              new Container(height: 1.0,),
                                              new Text('${snapshot.data![index].storeAddress}',
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
                                      new Spacer(flex: 1,),
                                      new Container(  //Divider
                                        height: 35.0,
                                        width: .5,
                                        color: Colors.black54,
                                        margin: const EdgeInsets.only(left:0, right: 10.0),
                                      ),
                                      new Container(
                                        width: 130,
                                        height: 72,
                                        child: FittedBox(
                                          child: Image.network('https://scontent.fceb1-2.fna.fbcdn.net/v/t39.30808-6/236991651_804507973568079_6434103538071546863_n.jpg?_nc_cat=109&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeHbOmdIvS-1sZYaJ_DPznmuxNeiLDwV6oDE16IsPBXqgNJMUCNUyv55C3R0Dlo8BBQ_bCNUc87kH5CkWVNGYKRx&_nc_ohc=X4ZeEwnSHx8AX9QNGdn&_nc_ht=scontent.fceb1-2.fna&oh=25c5bd6456425e447a611f5cf2a77ab8&oe=612AAB8F'),
                                        ),
                                      )

                                    ],
                                  ),
                                ),

                              )
                            );
                          }
                      );

                    },
                  )

                ],
                )
            ),
          ),
        ),

    );
  }


}


class SearchDb {

  late Database db;

  //Method to retrieve data from search_db_1 database
 Future<List<Store>> getStore(String searchCriteria) async {

   final database = openDatabase(
     join(await getDatabasesPath(), 'search_db_1.db'),
     onCreate: (db, version) {
       return db.execute(
         'CREATE TABLE search(id TEXT PRIMARY KEY, storeName TEXT, storeAddress TEXT, storeDbMap TEXT)',
       );
     },
     version: 2,
   );

   final db = await database;
   final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM search WHERE storeDbMap LIKE '%${searchCriteria}%'");

   return List.generate(maps.length, (i) {
     return Store(
         id: maps[i]['id'],
         storeName: maps[i]['storeName'],
         storeAddress: maps[i]['storeAddress'],
         storeDbMap: maps[i]['storeDbMap']
     );
   });


 }

}// SearchDb






class Store {
  final String id;
  final String storeName;
  final String storeAddress;
  final String storeDbMap;
  Store({
    required this.id,
    required this.storeName,
    required this.storeAddress,
    required this.storeDbMap
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'storeDbMap': storeDbMap
    };
  }
  @override
  String toString() {
    return 'Store{id: $id, storeName: $storeName, storeAddress: $storeAddress, storeDbMap: $storeDbMap}';
  }
}