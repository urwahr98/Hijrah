import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hijrah/widgets/provider_widget.dart';
import 'package:intl/intl.dart';

class LoanPage extends StatefulWidget {
  @override
  _LoanPageState createState() => _LoanPageState();

}

class _LoanPageState extends State<LoanPage>{
  var sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loan Request'),),
      body: Builder(
        builder: (context) => SingleChildScrollView(
        child: displayInfo(context),
      ),
      ),
    );
    throw UnimplementedError();
  }

  Widget displayInfo(context){
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);

    return Column(
      children: <Widget>[
        Padding(
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
          });
          },
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(child: Text("Your Loan : RM $sliderValue",
            style: TextStyle(color: Colors.black, fontSize: 22.0,fontWeight:FontWeight.bold),)),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
        ),
        RaisedButton(
          child: Text("Submit Loan Request"),
          onPressed: () async {
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
                      "dateRequest": formattedDate});
            _showToast(context);
          },
        ),

      ],
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

}