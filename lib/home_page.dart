import 'package:flutter/material.dart';
import 'package:hijrah/auth.dart';
import 'package:hijrah/loan_page.dart';
import 'package:hijrah/status_page.dart';
import 'package:hijrah/payment_page.dart';
import 'auth.dart';
import 'profile_page.dart';
import 'package:hijrah/widgets/provider_widget.dart';
import 'package:url_launcher/url_launcher.dart';
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child:Container(
          child: Center(
            child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buildButton(context),
          ),
        ),
      ),
      ),
    );
  }

  List<Widget> buildButton(context) {
    return [

      Padding(padding: const EdgeInsets.all(8.0),),

      // Image(image: AssetImage('images/logo.png'), height: 200,),

      GestureDetector(
        onLongPress: (){_launchURL();},
        child: Image.asset(
          'images/logo.png',
          fit: BoxFit.cover,
          height: 200,
        ),
      ),

      SizedBox( height: 50.0,),

      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        buttonColor: Colors.white60,
        child: RaisedButton.icon(
          icon: Icon(Icons.account_circle, size: 40,),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          label: Text("Profile", style: TextStyle(fontSize: 20.0)),
        ),
      ),

      SizedBox( height: 30.0,),

      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        buttonColor: Colors.white60,
        child: RaisedButton.icon(
          icon: Icon(Icons.attach_money, size: 40,),
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => LoanPage()
              )
            );
          },
          label: Text("Apply Loan", style: TextStyle(fontSize: 20.0)),
        ),
      ),

      SizedBox( height: 30.0,),

      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        buttonColor: Colors.white60,
        child: RaisedButton.icon(
          icon: Icon(Icons.payment, size: 40,),
          onPressed: () async {
            final uid =
            await Provider
                .of(context)
                .auth
                .getCurrentUID();
            Navigator.of(context)
                .push(
                MaterialPageRoute(
                    builder: (context) => PaymentPage(text: uid)
                )
            );
          },
          label: Text("Payment", style: TextStyle(fontSize: 20.0)),
        ),
      ),

      SizedBox( height: 30.0,),

      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        buttonColor: Colors.white60,
        child: RaisedButton.icon(
          icon: Icon(Icons.notifications, size: 40,),
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
          label: Text("Check Status", style: TextStyle(fontSize: 20.0)),
        ),
      ),

      SizedBox( height: 30.0,),

      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        buttonColor: Colors.white60,
        child: RaisedButton.icon(
          icon: Icon(Icons.exit_to_app, size: 40,),
          onPressed: _signOut,
          label: Text("Log Out", style: TextStyle(fontSize: 20.0)),
        ),
      ),

      SizedBox( height: 30.0,),

    ];
  }
  _launchURL() async {
    const url = 'https://www.hijrahselangor.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}