import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import  'package:eatnywhere/screens/home_page.dart';


Future <void> CgDbHelper() async {
  //WidgetsFlutterBinding.ensureInitialized();

  List<Map<dynamic, dynamic>> lists = [];
  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');

  //print("This... ${lists.toString()}");

  final database = openDatabase(
    join(await getDatabasesPath(), 'search_db_2.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE search(id TEXT PRIMARY KEY, storeName TEXT, storeAddress TEXT, storeDbMap TEXT, storePpUrl TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 2,
  );


  //Method to insert data on Store database
  Future<void> insertStore(Store store) async {
    // Get a reference to the database.
    final db = await database;
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'search',
      store.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  //Method to retrieve data from search_db_1 database
  Future<List<Store>> getStore() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all Stores.
    final List<Map<String, dynamic>> maps = await db.query('search');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
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

//DELETE
  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'search',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
  

//Method to update database
  Future<void> updateStore(Store store) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'search',
      store.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [store.id],
    );
  }

//CCG Search Query
  _query () async {
    Database db = await database;
    List<String> columnsToSelect = ['id','storeName','storeAddress'];
    String whereString = 'name = ?';
    String searchCriteria = "ketchup";
    //List<dynamic> whereArguments = [searchCriteria];
    List<Map> result = await db.rawQuery("SELECT * FROM search WHERE storeDbMap LIKE '%${searchCriteria}%'");
    // print the results
    result.forEach((row) => print(row));

  }


  _queryDelete () async {
    Database db = await database;
    db.delete("search");

  }

//Retrieve Stores from firebase and transfer to local db
  referenceDatabase.once().then((DataSnapshot snapshot) {
    _queryDelete();
    Map<dynamic, dynamic> values = snapshot.value;
    values.forEach((key, values) async {
      lists.add(values);
      //print('This is from QUERY --- ${values["StoreName"]} - ${values["StoreAddress"]} - ${key}');
      //print("${key}");
      var _store = Store(
          id: '${key.toString()}',
          storeName: '${values["StoreName"].toString()}',
          storeAddress: '${values["StoreAddress"].toString()}',
          storePpUrl: '${values["StorePhoto"].toString()}',
          storeDbMap: '${values.toString()}',

      );
      await insertStore (_store);
      //print('Trying to print firebase map -- ${values.toString()}');
    });
  });



  //print(await getStore());
 // await deleteDog(1);
  //_queryDelete();
  //_query();

}



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

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'storePpUrl': storePpUrl,
      'storeDbMap': storeDbMap
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Store{id: $id, storeName: $storeName, storeAddress: $storeAddress, storeDbMap: $storeDbMap, storePpUrl: $storePpUrl}';
  }
}