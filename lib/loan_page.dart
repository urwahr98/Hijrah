import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hijrah/widgets/provider_widget.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class LoanPage extends StatefulWidget {
  @override
  _LoanPageState createState() => _LoanPageState();

}

class _LoanPageState extends State<LoanPage>{
  var sliderValue = 1000.0;
  var scheme = "Skim 1";
  var icBack = false;
  var icFront = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loan Request'),),
      body: Builder(
        builder: (context) => SingleChildScrollView(
        child: FutureBuilder(
          future: Provider
              .of(context)
              .auth
              .getCurrentUID(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return displayInfo(context, snapshot);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      ),
    );
    throw UnimplementedError();
  }

  Widget displayInfo(context, snapshot){
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    bool icfront = false;
    bool icback = false;

    return Column(
      children: <Widget>[
        FutureBuilder(
        future: _getProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            icfront = snapshot.data['icFront'];
            icback = snapshot.data['icBack'];
          }

        return Column(
        children: <Widget>[Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Image(image: AssetImage('images/scheme.png'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Slider(
          min: 0,
          max: 50000,
          divisions: 20,
          value: sliderValue,
          onChanged: (newValue){
          setState(() {
            sliderValue = newValue;
            if (sliderValue < 6000) {
              scheme = "Skim 1";
            }else if(sliderValue > 6000 && sliderValue < 15000){
              scheme = "Skim 2";
            }else if(sliderValue > 15000 && sliderValue < 30000){
              scheme = "Skim 3";
            }else if(sliderValue > 30000){
              scheme = "Skim 4";
            }
          });
          },
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(child: Text("Your Loan : RM $sliderValue",
            style: TextStyle(color: Colors.black, fontSize: 22.0,fontWeight:FontWeight.bold),)),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(child: Text("Scheme :  $scheme",
            style: TextStyle(color: Colors.black, fontSize: 22.0,fontWeight:FontWeight.bold),)),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
        ),
        RaisedButton.icon(
          icon: Icon(Icons.check, size: 20, ),
          label: Text("Submit Loan Request"),
          onPressed: () async {
            var icFront = await IcFrontNull();
            var icBack = await IcBackNull();
            if (!icFront || !icBack) {
              dialog2(context);
            } else {

              final uid =
              await Provider
                  .of(context)
                  .auth
                  .getCurrentUID();
              await Provider
                  .of(context)
                  .db
                  .collection('userData')
                  .document(uid)
                  .collection('Loan')
                  .add({"amount": sliderValue,
                "status": "Pending",
                "dateRequest": formattedDate,
                "scheme": scheme});
              _showToast(context);
            }
          },
        ),

        SizedBox(height: 70,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                RaisedButton.icon(
                icon: Icon(Icons.file_upload, size: 20, ),
                label: Text("Upload front I.C. picture"),
                onPressed: () async {
                  uploadImage('icFront');
                  final uid =
                  await Provider
                      .of(context)
                      .auth
                      .getCurrentUID();
                  await Provider
                      .of(context)
                      .db
                      .collection('userData')
                      .document(uid)
                      .setData({"icFront": true,}, merge:true);
                }
                ),
                SizedBox(width: 20,),
              (!icfront)?
              Icon(Icons.clear) : Icon(Icons.check)
              ]
        ),

        SizedBox(height: 20,),

        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                  icon: Icon(Icons.file_upload, size: 20, ),
                  label: Text("Upload back I.C. picture"),
                  onPressed: () async {
                    uploadImage('icBack');
                    final uid =
                    await Provider
                        .of(context)
                        .auth
                        .getCurrentUID();
                    await Provider
                        .of(context)
                        .db
                        .collection('userData')
                        .document(uid)
                        .setData({"icBack": true,}, merge:true);
                  }
              ),
              SizedBox(width: 20,),
              (!icback)?
                Icon(Icons.clear) : Icon(Icons.check)
            ]
        ),

      ],
    );
    }
    )
    ]
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Loan request made.'),
        action: SnackBarAction(
            label: 'Okay',
            onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  uploadImage(String img) async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    final uid = await Provider
        .of(context)
        .auth
        .getCurrentUID();
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
        DateFormat dateFormat = DateFormat("yyyy_MM_dd_HH_mm_ss");
        String datenow = dateFormat.format(DateTime.now());

        String photoname = 'IC/' + uid + '/' + img + '_' + datenow;
        await _storage.ref().child(photoname).putFile(file).onComplete;


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

  void dialog2(BuildContext context) {

    var alertDialog = AlertDialog(
      title: Text("Please upload I.C photos first!"),
    );

    showDialog(context: context,
        builder: (BuildContext context){
          return alertDialog;
        }
    );
  }

  IcFrontNull() async {
    var icFront;
    final uid = await Provider
        .of(context)
        .auth
        .getCurrentUID();
    await Provider
        .of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      icFront = result.data['icFront'];
    });
    return icFront;
  }

  IcBackNull() async {
    var icBack;
    final uid = await Provider
        .of(context)
        .auth
        .getCurrentUID();
    await Provider
        .of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      icBack = result.data['icBack'];
    });
    return icBack;
  }

  _getProfileData() async {
    final uid = await Provider
        .of(context)
        .auth
        .getCurrentUID();
    var data = await Provider
        .of(context)
        .db
        .collection('userData')
        .document(uid)
        .get();
    return data;
        }

  }

