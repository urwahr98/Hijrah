import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hijrah/widgets/provider_widget.dart';


class StatusPage extends StatefulWidget {
  final String text;
  StatusPage({Key key, @required this.text}) : super(key: key);
  @override
  _StatusPageState createState() => _StatusPageState(text);
}

class _StatusPageState extends State<StatusPage> {

  String text;

  _StatusPageState(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loan Status'),),
      body: StreamBuilder(
        stream: Firestore.instance.collection('userData')
            .document(text)
            .collection('Loan').snapshots(),
        builder: buildLoanList,
      ),
    );
  }

  Widget buildLoanList(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) {
          DocumentSnapshot user = snapshot.data.documents[index];

          return Card(
            child: ListTile(
              title: Text("RM " + user.data['amount'].toString()),
              subtitle: Text("Status: " + user.data['status'].toString()
                  + "\n" + user.data['dateRequest'].toString()),
              isThreeLine: true,
              trailing: IconButton(
                  icon: Icon(Icons.delete_forever),
                  // onPressed: () => showAlertDialog(context),
                onPressed: () {
                    Firestore.instance.collection('userData').document(text).collection('Loan').document(user.documentID).delete();
                },
              ),

            ),
          );
        },
      );
    } else
    if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
      return Center(
        child: Text("No loan found."),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Delete"),
      onPressed: () {

        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Delete this loan request?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

