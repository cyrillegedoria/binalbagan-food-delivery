import 'package:eatnywhere/screens/add_business_page.dart';
import 'package:eatnywhere/screens/select_menu_page.dart';
import 'package:eatnywhere/services/sqflite_search_query.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:eatnywhere/services/firebase_service.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
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
    //WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    CgDbHelper();
    searchTf.addListener(_onSearchChanged);
  }

  @override
  void dispose(){
    searchTf.removeListener(_onSearchChanged);
    searchTf.dispose();
    super.dispose();
  }

  _onSearchChanged(){
   setState(() {searchTf.text;});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SearchDb searchDb = SearchDb();

    return Scaffold(
      backgroundColor: Constants.cPrimaryColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget> [
              Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text("Hi ${user!.displayName},",
                                      style: GoogleFonts.signika(color: Constants.cPink,fontSize: 20,fontWeight: FontWeight.w200),
                                    ),
                                  )
                              ),
                              Spacer(flex: 1,),
                              Container(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(user!.photoURL!),
                                  radius: 15,
                                ),
                              ),
                              Container(width: 5,),
                              // Container(
                              //  child: Text(user!.displayName!),
                              // ),
                              user!.email == "georginasniper@gmail.com"?
                              Container(
                                width: 30,
                                height: 30,
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle
                                ),
                                child: IconButton(
                                    onPressed: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => AddBusinessPage()));
                                    },
                                    icon: Icon(
                                      Icons.add_business,
                                      color: Constants.cPink,
                                      size: 16,
                                    )
                                ),
                              ): Container(),
                              user!.email == "georginasniper@gmail.com"?Container(width: 5,): Container(),
                              Container(
                                width: 30,
                                height: 30,
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.logout,
                                    color: Constants.cPink,
                                    size: 16,
                                  ),
                                  onPressed: () async {
                                    FirebaseService service = new FirebaseService();
                                    await service.signOutFromGoogle();
                                    Navigator.pushReplacementNamed(
                                        context, Constants.welcomeNavigate);
                                  },
                                ),
                              ),
                              Container(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),)
                            ],
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text("Grab your",
                                style: GoogleFonts.signika(color: Constants.cPink,fontSize: 40,fontWeight: FontWeight.w500),
                              ),
                            )
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text("delicious meal.",
                                style: GoogleFonts.signika(color: Constants.cPink,fontSize: 55,fontWeight: FontWeight.w600),
                              ),
                            )
                          ),
                          SizedBox(height: 10,),
                          SizedBox(
                            width: size.width * .8,
                            child: Container(
                                child: TextField(
                                  controller: searchTf,
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding:
                                      EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      prefixIcon: Icon(Icons.search_sharp, color: Colors.grey,),
                                      hintText: "Search for food or stores  ",
                                      hintStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 26,fontWeight: FontWeight.w100),
                                  ),
                                )
                            ),
                          ),
                          SizedBox(height: 20),

                        ],
                      ),
                      FutureBuilder<List<Store>>(

                        future: searchDb.getStore(searchTf.text),
                        builder: (context,AsyncSnapshot<List<Store>> snapshot){

                          if(!snapshot.hasData){
                            searchTf.clear();
                            return CircularProgressIndicator(color: Constants.cLightGreen,);
                          }
                          else {
                              return GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  mainAxisSpacing: 1,
                                  crossAxisCount: 2,
                                  children: List.generate(snapshot.data!.length, (index){

                                    return InkWell(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectMenuPage(
                                                      '${snapshot.data![index]
                                                          .id}')));
                                      },
                                      child: SizedBox(
                                        child: Container(
                                          margin: EdgeInsets.all(8),
                                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Constants.cLightGreen,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          child:  Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget> [
                                              Spacer(),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text('${snapshot.data![index].storeName}',
                                                  style: GoogleFonts.signika(color: Constants.cPink,fontSize: 20,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text("${snapshot.data![index].storeAddress}",
                                                  style: GoogleFonts.signika(color: Constants.cPink,fontSize: 12,fontWeight: FontWeight.w300),
                                                ),
                                              ),
                                              Spacer(flex: 1,),
                                              Container(
                                                  width: size.width*.3,
                                                  height: size.height*.15,
                                                  padding: EdgeInsets.all(0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,

                                                  ),
                                                  child:FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.transparent,
                                                      backgroundImage: NetworkImage('${snapshot.data![index].storePpUrl.toString()}'),
                                                    ),
                                                  )
                                              ),
                                              Spacer()

                                            ],
                                          ),
                                        ),
                                      ),
                                    );

                                  },
                                 )
                                );

                          }
                        },
                      )

                    ],
                  )
              ),
            ],
          )
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
     join(await getDatabasesPath(), 'search_db_2.db'),
     onCreate: (db, version) {
       return db.execute(
         'CREATE TABLE search(id TEXT PRIMARY KEY, storeName TEXT, storeAddress TEXT, storePpUrl TEXT, storeDbMap TEXT)',
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
         storePpUrl: maps[i]['storePpUrl'],
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
  final String storePpUrl;

  Store({
    required this.id,
    required this.storeName,
    required this.storeAddress,
    required this.storePpUrl,
    required this.storeDbMap
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'storePpUrl': storePpUrl,
      'storeDbMap': storeDbMap
    };
  }
  @override
  String toString() {
    return 'Store{id: $id, storeName: $storeName, storeAddress: $storeAddress, storeDbMap: $storeDbMap, storePpUrl: $storePpUrl}';
  }
}