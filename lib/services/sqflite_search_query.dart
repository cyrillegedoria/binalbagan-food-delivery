import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future <void> CcgSearch() async {
  WidgetsFlutterBinding.ensureInitialized();


  List<Map<dynamic, dynamic>> lists = [];
  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');

  //print("This... ${lists.toString()}");

  final database = openDatabase(
    join(await getDatabasesPath(), 'search_db.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE search(id TEXT PRIMARY KEY, storeName TEXT, storeAddress TEXT)',
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
    String searchCriteria = "Y";
    //List<dynamic> whereArguments = [searchCriteria];
    List<Map> result = await db.rawQuery("SELECT * FROM search WHERE storeName LIKE '%${searchCriteria}%' OR storeAddress LIKE '%${searchCriteria}%'");
    // print the results
    result.forEach((row) => print(row));
    // {_id: 1, name: Bob, age: 23}

  }


  _queryDelete () async {
    Database db = await database;
    db.delete("search");

  }


  referenceDatabase.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> values = snapshot.value;
    values.forEach((key, values) async {
      lists.add(values);
      //print('This is from QUERY --- ${values["StoreName"]} - ${values["StoreAddress"]} - ${key}');
      //print("${key}");
      var _store = Store(
          id: '${key.toString()}',
          storeName: '${values["StoreName"].toString()}',
          storeAddress: '${values["StoreAddress"].toString()}',
      );

      await insertStore (_store);

    });
  });



  print(await store());
 // await deleteDog(1);
  //_queryDelete();

  //_query();
}



class Store {
  final String id;
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