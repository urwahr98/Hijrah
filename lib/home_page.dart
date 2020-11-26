import 'package:flutter/material.dart';
import 'package:hijrah/auth.dart';
import 'package:hijrah/loan_page.dart';
import 'package:hijrah/status_page.dart';
import 'auth.dart';
import 'profile_page.dart';
import 'package:hijrah/widgets/provider_widget.dart';
import 'models/User.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignedOut});

  final Auth auth;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hijrah"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildButton(context),
          ),
        ),
      ),
    );
  }

  List<Widget> buildButton(context) {
    return [
      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        buttonColor: Colors.white60,
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          child: Text("Profile", style: TextStyle(fontSize: 20.0)),
        ),
      ),

      SizedBox( height: 20.0,),

      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        buttonColor: Colors.white60,
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => LoanPage()
              )
            );
          },
          child: Text("Apply Loan", style: TextStyle(fontSize: 20.0)),
        ),
      ),

      SizedBox( height: 20.0,),

      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        buttonColor: Colors.white60,
        child: RaisedButton(
          onPressed: () async {
            final uid =
            await Provider
                .of(context)
                .auth
                .getCurrentUID();
            Navigator.of(context)
                .push(
                MaterialPageRoute(
                    builder: (context) => StatusPage(text: uid)
                )
            );

          },
          child: Text("Check Status", style: TextStyle(fontSize: 20.0)),
        ),
      ),

      SizedBox( height: 20.0,),

      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        buttonColor: Colors.white60,
        child: RaisedButton(
          onPressed: _signOut,
          child: Text("Log Out", style: TextStyle(fontSize: 20.0)),
        ),
      ),

    ];
  }
}