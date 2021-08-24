import 'dart:core';
import 'package:firebase_database/firebase_database.dart';


class CGList{
late String storeName;
late String storeAddress;

CGList({required this.storeName,required this.storeAddress});

CGList.fromSnapshot(DataSnapshot snapshot) :
    storeName = snapshot.value["StoreName"],
      storeAddress = snapshot.value["StoreAddress"];

toJson(){
  return  {
     "storeName":storeName,
     "storeLocation":storeAddress
  };
}

}