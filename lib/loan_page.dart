import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hijrah/widgets/provider_widget.dart';

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
      body: SingleChildScrollView(
        child: displayInfo(context),
      ),
    );
    throw UnimplementedError();
  }

  Widget displayInfo(context){
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
          onPressed: (){},
        ),

      ],
    );
  }

}