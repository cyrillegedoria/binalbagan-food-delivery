import 'dart:io';
import 'package:eatnywhere/screens/add_menu_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:eatnywhere/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';



class AddBusinessPage extends StatefulWidget{

  late final FirebaseApp app;
  late bool isLoading = false;

  @override
  _AddBusinessPage createState() => _AddBusinessPage();


}

class _AddBusinessPage extends State <AddBusinessPage>{
  User? user = FirebaseAuth.instance.currentUser;
  final referenceDatabase = FirebaseDatabase.instance.reference();
  final storeNameTf = TextEditingController();
  final addressTf = TextEditingController();
  final storeUrlTf = TextEditingController();



  @override
  Widget build(BuildContext context) {

    final storesRef = referenceDatabase.reference();
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.cPrimaryColor,
        title: Row(
          children: [

            Container(
              child: Text('Add Store'),
            ),
            Spacer(flex: 1,),
            IconButton(
                onPressed: (){
                      Navigator.pushReplacementNamed(
                      context, Constants.homeNavigate);
                },
                icon: Icon(
                    Icons.home,
                    color: Constants.cPink,
                    size:   30,
                )
            ),

          ],
        ),
      ),
      backgroundColor: Constants.cPrimaryColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              child: Column(
                children:<Widget> [

                  SizedBox(height: 10,),
                  SizedBox(
                    child: Container(
                      width: size.width*.7,
                      height: size.height*0.045,
                      child: TextField(
                        controller:  storeNameTf ,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            EdgeInsets.all(15),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Constants.cPink),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintText: "Store Name",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            )
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  SizedBox(
                    child: Container(
                      width: size.width*.7,
                      height: size.height*0.045,
                      child: TextField(
                        controller:  addressTf ,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            EdgeInsets.all(15),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Constants.cPink),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintText: "Address",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            )
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(
                        child: Container(
                          width: size.width*.1,
                          //height: size.height*.05,
                          child: TextButton(
                            onPressed: (){
                              setState(() {
                                widget.isLoading = true;
                              });
                              PickImage()._onImageButtonPressed(ImageSource.gallery, context: context).then((value) => setState((){storeUrlTf.text=value;widget.isLoading=false;}));

                            },
                            child: Icon(Icons.photo_library_rounded, size: 18),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    )
                                )
                            ),
                          ),
                        ),
                      ),
                      Container(width: 10,),
                      widget.isLoading==false?
                      SizedBox(
                        child: Container(
                          width: size.width*.5,
                          //height: size.height*.05,
                          child: TextButton(
                            onPressed: (){

                              if (storeNameTf.text=="" || addressTf.text=="")
                              {
                                Fluttertoast.showToast(msg: "Please fill the form.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                );
                              }
                              else {
                                storesRef
                                    .child('StoresList')
                                    .push()
                                    .set({'StoreName':storeNameTf.text, 'StoreAddress':addressTf.text,'StorePhoto':storeUrlTf.text})
                                    .asStream();

                                Fluttertoast.showToast(msg: "Success!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                );

                                storeNameTf.clear();
                                addressTf.clear();
                                storeUrlTf.clear();
                              }

                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Constants.cPink
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
                          ),
                        ),
                      )

                      :CircularProgressIndicator(color: Constants.cLightGreen,)

                    ],
                  ),

                  SizedBox(height: 10,),

                  FirebaseAnimatedList(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      query: referenceDatabase.child('StoresList'),
                      itemBuilder: (BuildContext context,
                          DataSnapshot snapshot,
                          Animation<double> animation,
                          int index)
                      {
                        return  new ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),

                          onPressed:() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMenuPage('${snapshot.key}')));
                          },

                          child: new ListTile(
                            tileColor: Colors.transparent,
                            dense: true,
                            //enabled: true,
                            //hoverColor: Colors.black,
                            visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                            minVerticalPadding:12,
                            title: new Text(
                              '${snapshot.value['StoreName'].toString().toUpperCase()}',
                              style: TextStyle(  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.cPink
                              ),
                            ),
                            trailing: IconButton(icon: Icon(Icons.delete),
                              onPressed: () => referenceDatabase.child('StoresList').child('${snapshot.key}').remove(),
                            ),
                          ),
                        );
                      }
                  ),


                ],
              )

          ),
        ),
      )
    );

  }
  
}


class PickImage {

  late File _image;
  late String url;

  Future  _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    final pickedFile =  await ImagePicker().pickImage(source:source);
    _image = File(pickedFile!.path);


    String filename = pickedFile.path.split('/').last;
    Reference storageReference = FirebaseStorage.instance.ref("store profile/$filename");
    final UploadTask uploadTask = storageReference.putFile(_image);
    final TaskSnapshot downloadUrl = (await uploadTask);
    url = await downloadUrl.ref.getDownloadURL();
    //print("Check Path xxx - $url");
    return url;
  }




}



