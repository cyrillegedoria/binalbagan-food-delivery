import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


void CcgSearch() async {

  WidgetsFlutterBinding.ensureInitialized();

  //List<Map<dynamic, dynamic>> lists = [];
  //final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');

  final database = openDatabase(

    join(await getDatabasesPath(), 'search_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE search(id INTEGER PRIMARY KEY, storeName TEXT, storeAddress TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
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


  //Method to retrieve data from Store database
  Future<List<Store>> store() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('search');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Store(
        id: maps[i]['id'],
        storeName: maps[i]['storeName'],
        storeAddress: maps[i]['storeAddress'],
      );
    });
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
    String searchCriteria = "Y";
    //List<dynamic> whereArguments = [searchCriteria];
    List<Map> result = await db.rawQuery("SELECT * FROM search WHERE storeName LIKE '%${searchCriteria}%' OR storeAddress LIKE '%${searchCriteria}%'");
    // print the results
    result.forEach((row) => print(row));
    // {_id: 1, name: Bob, age: 23}

  }






  var store0 = Store(
    id: 0,
    storeName: 'Rainbrew',
    storeAddress: 'San Pedro',
  );

  var store1 = Store(
    id: 1,
    storeName: 'Kitty Cafe',
    storeAddress: 'San Teodoro',
  );

  var store2 = Store(
    id: 2,
    storeName: 'Cyrille',
    storeAddress: 'Paglaum, Village 1',
  );


  await insertStore(store0);
  await insertStore(store1);
  await insertStore(store2);



  print(await store());
  //_query();
}



class Store {
  final int id;
  final String storeName;
  final String storeAddress;

  Store({
    required this.id,
    required this.storeName,
    required this.storeAddress,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeName': storeName,
      'storeAddress': storeAddress,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Store{id: $id, storeName: $storeName, storeAddress: $storeAddress}';
  }
}