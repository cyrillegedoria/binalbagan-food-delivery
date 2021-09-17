import 'dart:io';
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



class AddMenuItem extends StatefulWidget{

  final String storeId;
  final String reference;
  AddMenuItem ({required this.storeId,required this.reference});

  late bool isLoading = false;


  @override
  _AddMenuItem createState() => _AddMenuItem();

}


class _AddMenuItem extends State <AddMenuItem>{

  var itemName = TextEditingController();
  var itemPrice = TextEditingController();
  var itemDescription = TextEditingController();
  var itemUrl = TextEditingController();
  var referenceDatabase = FirebaseDatabase.instance.reference().child('StoresList');



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // TODO: implement build
    return Scaffold(
      backgroundColor: Constants.cPrimaryColor.withOpacity(.5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              child: Column(
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: Icon(Icons.post_add,color: Constants.cRed,),
                    label: Text("Add Item",
                      style: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w400),),
                    style: ElevatedButton.styleFrom(
                      primary: Constants.cLightOrange,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {

                      itemName.clear();
                      itemPrice.clear();
                      itemDescription.clear();
                      itemUrl.clear();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState){

                              return AlertDialog(
                                scrollable: true,
                                title: Text('New Item',
                                  style: GoogleFonts.signika(color: Constants.cRed,fontSize: 22,fontWeight: FontWeight.w400),),
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
                                                PickImage()._onImageButtonPressed(ImageSource.gallery, context: context).then((value) => setState((){itemUrl.text=value;widget.isLoading=false;}));
                                              },
                                              child: itemUrl.text.isEmpty?Icon(widget.reference=="MenuList"?Icons.restaurant_menu:widget.reference=="BeverageList"?Icons.emoji_food_beverage:Icons.post_add_sharp, size:100):FittedBox(child: CircleAvatar(backgroundImage: NetworkImage('${itemUrl.text}'),backgroundColor: Colors.white,maxRadius: 60,), fit: BoxFit.fitWidth,),
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: itemName,
                                          decoration: InputDecoration(
                                            labelStyle: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w300),
                                            labelText: "Item Name",
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            EdgeInsets.all(15),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Constants.cRed),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Constants.cRed),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                        Container(height: 10,),
                                        TextFormField(
                                          controller: itemPrice,
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                                          decoration: InputDecoration(
                                            labelStyle: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w300),
                                            labelText: "Price",
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            EdgeInsets.all(15),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Constants.cRed),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Constants.cRed),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                        Container(height: 10,),
                                        TextFormField(
                                          controller: itemDescription,
                                          maxLength: 40,
                                          decoration: InputDecoration(
                                            labelStyle: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w300),
                                            labelText: "Description",
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            EdgeInsets.all(15),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Constants.cRed),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Constants.cRed),
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
                                        style: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w400),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Constants.cLightOrange),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16.0),
                                              )
                                          )
                                      ),
                                      onPressed: () {
                                        if (itemName.text=="" || itemPrice.text=="" || itemDescription.text=="")
                                        {
                                          Fluttertoast.showToast(msg: "Please fill the form.",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.TOP,
                                          );
                                        }
                                        else{
                                          referenceDatabase
                                              .child('${widget.storeId}')
                                              .child(widget.reference)
                                              .child('${itemName.text}')
                                              .update({'Name':itemName.text,'Description':itemDescription.text,'Price':itemPrice.text,'MenuUrl':itemUrl.text})
                                              .asStream();

                                          itemName.clear();
                                          itemPrice.clear();
                                          itemDescription.clear();
                                          itemUrl.clear();
                                          Navigator.pop(context);
                                        }
                                      }
                                  )
                                      :CircularProgressIndicator(color: Constants.cLightOrange,)
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
                      query: referenceDatabase.child('${widget.storeId}').child(widget.reference),
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
                                height: 35.0,
                                width: .2,
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
                                              style: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w200)
                                          )
                                      ),
                                      new Container(height: 5.0,),
                                      new Text('${snapshot.value['Description']}',
                                          style: GoogleFonts.signika(color: Constants.cRed,fontSize: 12,fontWeight: FontWeight.w100)
                                      ),
                                      //  new Divider(height: 15.0,color: Colors.red,),
                                    ],
                                  )
                                ],
                              ),
                              new Spacer(flex: 1),
                              new IconButton(
                                icon: Icon(Icons.edit, color: Constants.cRed,),
                                onPressed: (){

                                  itemName.clear();
                                  itemPrice.clear();
                                  itemDescription.clear();
                                  itemUrl.clear();

                                  itemName.text = snapshot.value['Name'];
                                  itemPrice.text = snapshot.value['Price'];
                                  itemDescription.text = snapshot.value['Description'];
                                  itemUrl.text = snapshot.value['MenuUrl'];


                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState){

                                          return AlertDialog(
                                            scrollable: true,
                                            title: Text('Edit Item',
                                              style: GoogleFonts.signika(color: Constants.cRed,fontSize: 22,fontWeight: FontWeight.w400),),
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
                                                            PickImage()._onImageButtonPressed(ImageSource.gallery, context: context).then((value) => setState((){itemUrl.text=value;widget.isLoading=false;}));
                                                          },
                                                          child: itemUrl.text.isEmpty?Icon(widget.reference=="MenuList"?Icons.restaurant_menu:widget.reference=="BeverageList"?Icons.emoji_food_beverage:Icons.post_add_sharp, size:100):FittedBox(child: CircleAvatar(backgroundImage: NetworkImage('${itemUrl.text}'),backgroundColor: Colors.white,maxRadius: 60,), fit: BoxFit.fitWidth,),
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      controller: itemName,
                                                      decoration: InputDecoration(
                                                        labelStyle: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w300),
                                                        labelText: "Item Name",
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        contentPadding:
                                                        EdgeInsets.all(15),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Constants.cRed),
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Constants.cRed),
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(height: 10,),
                                                    TextFormField(
                                                      controller: itemPrice,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                                                      decoration: InputDecoration(
                                                        labelStyle: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w300),
                                                        labelText: "Price",
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        contentPadding:
                                                        EdgeInsets.all(15),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Constants.cRed),
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Constants.cRed),
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(height: 10,),
                                                    TextFormField(
                                                      controller: itemDescription,
                                                      maxLength: 40,
                                                      decoration: InputDecoration(
                                                        labelStyle: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w300),
                                                        labelText: "Description",
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        contentPadding:
                                                        EdgeInsets.all(15),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Constants.cRed),
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Constants.cRed),
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
                                                    style: GoogleFonts.signika(color: Constants.cRed,fontSize: 18,fontWeight: FontWeight.w400),
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(Constants.cLightOrange),
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16.0),
                                                          )
                                                      )
                                                  ),
                                                  onPressed: () {
                                                    if (itemName.text=="" || itemPrice.text=="" || itemDescription.text=="")
                                                    {
                                                      Fluttertoast.showToast(msg: "Please fill the form.",
                                                        toastLength: Toast.LENGTH_LONG,
                                                        gravity: ToastGravity.TOP,
                                                      );
                                                    }
                                                    else{
                                                      referenceDatabase
                                                          .child('${widget.storeId}')
                                                          .child(widget.reference)
                                                          .child('${itemName.text}')
                                                          .update({'Name':itemName.text,'Description':itemDescription.text,'Price':itemPrice.text,'MenuUrl':itemUrl.text})
                                                          .asStream();

                                                      itemName.clear();
                                                      itemPrice.clear();
                                                      itemDescription.clear();
                                                      itemUrl.clear();
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                              )
                                                  :CircularProgressIndicator(color: Constants.cLightOrange,)
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );

                                },
                              ),
                              new IconButton(
                                icon: Icon(Icons.delete, color: Constants.cRed,),
                                onPressed: () => referenceDatabase.child('${widget.storeId}').child('${widget.reference}').child('${snapshot.key}').remove(),
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