import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:hijrah/widgets/provider_widget.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


class PaymentPage extends StatefulWidget {
  final String text;
  PaymentPage({Key key, @required this.text}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState(text);
}

class _PaymentPageState extends State<PaymentPage> {

  String text;
  String imageURL;

  _PaymentPageState(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Page'),),
      body: SingleChildScrollView(
        child:Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),

          Text("Your Payment for ", style: TextStyle(fontSize: 40.0)),
          Text("January 2021:", style: TextStyle(fontSize: 30.0)),

          SizedBox(height: 20.0,),

          Text("RM 300/month", style: TextStyle(fontSize: 30.0, color: Colors.red)),

          SizedBox(height: 10.0,),

          (imageURL == null)
              ? Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text('You have not pay for January 2021 yet!',
                  style: TextStyle(fontSize: 22, color: Colors.redAccent), textAlign: TextAlign.center,))
              : Text('Waiting approval for payment.', style: TextStyle(fontSize: 20.0, color: Colors.lightBlue,), textAlign: TextAlign.center,),

          SizedBox(height: 20.0,),

          (imageURL != null)
              ? Image.network(imageURL)
                : Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
                border: Border.all(width: 2,)),
            child: Icon(
              Icons.photo_camera,
              color: Colors.black45,
              size: 200,
            ),
          ),

          SizedBox(height: 50.0,),

          RaisedButton.icon(
            padding: EdgeInsets.all(20.0),
            icon: Icon(Icons.insert_photo),
            label: Text('Upload Image', style: TextStyle(fontSize: 20.0)),
            onPressed: () => uploadImage(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),

        ],
      ),
      ),
    );
    throw UnimplementedError();
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //check permission
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted){
      // Select image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null) {
        // upload to firebase
        DateFormat dateFormat = DateFormat("yyyy_MM/dd_HH_mm_ss");
        String datenow = dateFormat.format(DateTime.now());

        String photoname = 'payment/' + text + '/' + datenow;
        var snapshot = await _storage.ref().child(photoname).putFile(file).onComplete;

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageURL = downloadUrl;
        }
        );

        dialog(context);

      }else {
        print('No path received');
      }
    }else {
      print('Grant Permission and try again!');
    }

  }

  void dialog(BuildContext context) {

    var alertDialog = AlertDialog(
      title: Text("Image has been succesfully uploaded!"),
    );

    showDialog(context: context,
    builder: (BuildContext context){
      return alertDialog;
    }
    );
  }


}

