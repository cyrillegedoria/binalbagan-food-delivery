import 'dart:io';
import 'package:eatnywhere/custom%20widgets/add_menu_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatnywhere/utils/constants.dart';
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

  final referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');
  late Map<dynamic, dynamic> _mapVal;
  late String storeName="";

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
            elevation: 3,
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
                  color: Constants.cLightOrange),
              labelColor: Constants.cRed,
              unselectedLabelColor: Colors.grey,
              labelStyle:GoogleFonts.signika(color: Constants.cRed,fontSize: 16,fontWeight: FontWeight.w400),

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
      children:<Widget>[
        AddMenuItem(storeId: widget.storeId ,reference: 'MenuList',),
        AddMenuItem(storeId: widget.storeId ,reference: 'BeverageList',),
        AddMenuItem(storeId: widget.storeId ,reference: 'ExtrasList',),
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