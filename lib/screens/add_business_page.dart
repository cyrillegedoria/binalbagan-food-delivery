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
import 'package:google_fonts/google_fonts.dart';
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

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
                              PickImage()._onImageButtonPressed(ImageSource.gallery, context: context).then((value) => setState((){storeUrlTf.text=value;widget.isLoading=false;}));
                            },
                            child: storeUrlTf.text.isEmpty?Icon(Icons.account_circle, size: 100):FittedBox(child: CircleAvatar(backgroundImage: NetworkImage('${storeUrlTf.text}'),backgroundColor: Colors.white,maxRadius: 60,), fit: BoxFit.fitWidth,),
                          ),
                        ),
                      ),
                      Container(width: 10,),

                      Column(
                        children: [
                          SizedBox(
                            child: Container(
                              width: size.width*.5,
                              height: size.height*.045,
                              child: TextField(
                                controller:  storeNameTf ,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Constants.cPink),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    hintText: "Store Name",
                                    hintStyle: GoogleFonts.signika(color: Constants.cPink,fontSize: 16,fontWeight: FontWeight.w100),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          SizedBox(
                            child: Container(
                              width: size.width*.5,
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
                                    hintStyle:GoogleFonts.signika(color: Constants.cPink,fontSize: 16,fontWeight: FontWeight.w100),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
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

                                    setState(() {
                                      storeNameTf.clear();
                                      addressTf.clear();
                                      storeUrlTf.clear();
                                    });
                                  }

                                },
                                child: Text(
                                  'Save',
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
                              ),
                            ),
                          )

                              :CircularProgressIndicator(color: Constants.cLightGreen,)

                        ],
                      ),

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
                        return new InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMenuPage('${snapshot.key}')));
                          },
                          child: Card(
                            elevation: 2,
                            child: new Row(
                              children:<Widget> [

                                new Container(
                                  width: 64,
                                  height: 80,
                                  padding: EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage('${snapshot.value['StorePhoto'].toString()}'),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                new Container(width: 10,),
                                new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget> [
                                    new Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('${snapshot.value['StoreName'].toString().toUpperCase()}' ,
                                        style: GoogleFonts.signika(color: Constants.cPink,fontSize: 18,fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    new Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('${snapshot.value['StoreAddress'].toString().toUpperCase()}' ,
                                        style: GoogleFonts.signika(color: Constants.cPink,fontSize: 14,fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(flex: 1,),
                                new Container(
                                  child: IconButton(icon: Icon(Icons.delete, color: Colors.grey,),
                                    onPressed: () => referenceDatabase.child('StoresList').child('${snapshot.key}').remove(),
                                  ),
                                )

                              ],
                            ),
                          )
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
    final pickedFile =  await ImagePicker().pickImage(source:source,imageQuality: 40,maxHeight: 600, maxWidth: 600);
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



