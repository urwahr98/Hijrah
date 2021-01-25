import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:hijrah/auth.dart';
// import 'auth.dart';
import 'models/User.dart';
import 'package:hijrah/widgets/provider_widget.dart';
import 'package:intl/intl.dart';



class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = User("", "", "", "", "");
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userAddressController = TextEditingController();
  TextEditingController _userICnumController = TextEditingController();
  TextEditingController _userPhoneNumController = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();
  TextEditingController _userBirthday = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Profile")
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: Provider
                  .of(context)
                  .auth
                  .getCurrentUID(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return displayUserInfromation(context, snapshot);
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget displayUserInfromation(context, snapshot) {
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: _getProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _userNameController.text = user.name;
              _userAddressController.text = user.address;
              _userPhoneNumController.text = user.phoneNum;
              _userICnumController.text = user.ICnum;
              _userBirthday.text = user.birthday;
            }
            return Container(
              alignment: Alignment(0.0, 0.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.account_circle, size: 100),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Name: ${_userNameController.text}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                  FlatButton.icon(
                    label: Text("Change Name", style: TextStyle(color: Colors.blue),),
                    onPressed: (){
                      _userEditBottomSheetName(context);
                    },
                    icon: Icon(Icons.mode_edit, size: 17, color: Colors.blue,),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "IC Number: ${_userICnumController.text}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                  FlatButton.icon(
                    label: Text("Input Ic Number", style: TextStyle(color: Colors.blue),),
                    onPressed: (){
                      _userEditBottomSheetICNum(context);
                    },
                    icon: Icon(Icons.mode_edit, size: 17, color: Colors.blue,),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Phone Number: ${_userPhoneNumController.text}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                  FlatButton.icon(
                    label: Text("Change Phone Number", style: TextStyle(color: Colors.blue),),
                    onPressed: (){
                      _userEditBottomSheetPhoneNum(context);
                    },
                    icon: Icon(Icons.mode_edit, size: 17, color: Colors.blue,),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Address: ${_userAddressController.text}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                  FlatButton.icon(
                    label: Text("Change Address", style: TextStyle(color: Colors.blue),),
                    onPressed: (){
                      _userEditBottomSheetAddress(context);
                    },
                    icon: Icon(Icons.mode_edit, size: 17, color: Colors.blue,),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Birthday: ${_userBirthday.text}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                  FlatButton.icon(
                    label: Text("Change Birthday", style: TextStyle(color: Colors.blue),),
                    onPressed: (){
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1973, 1, 1),
                          maxTime: DateTime(2002, 12, 31), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) async {
                        String formattedDate = DateFormat('dd/MM/yyyy').format(date);
                        user.birthday = formattedDate;
                        setState(() {
                          _userBirthday.text = user.birthday;
                        });
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
                            .setData(user.toJson(), merge:true);
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    icon: Icon(Icons.mode_edit, size: 17, color: Colors.blue,),
                  ),

                ],
              ),
            );
          },
        ),
        SizedBox(height: 20.0),

        RaisedButton.icon(
          icon: Icon(Icons.lock, size: 20, ),
          label: Text("Change Password",),
          onPressed: (){
            _changePassword(context);
          },
        ),

        SizedBox(height: 50.0),

      ],
    );
  }

  _getProfileData() async {
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
      user.name = result.data['name'];
      user.address = result.data['address'];
      user.phoneNum = result.data['phoneNum'];
      user.ICnum = result.data['ICnum'];
      user.birthday = result.data['birthday'];
    });
  }

  void _userEditBottomSheetName(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height * .80,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Update Profile"),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.orange,
                      iconSize: 25,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                            helperText: "Name",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Save'),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () async {
                        user.name = _userNameController.text;
                        setState(() {
                          _userNameController.text = user.name;
                        });
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
                            .setData(user.toJson(), merge:true);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _userEditBottomSheetPhoneNum(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height * .80,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Update Profile"),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.orange,
                      iconSize: 25,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _userPhoneNumController,
                          decoration: InputDecoration(
                            helperText: "New Phone Number",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Save'),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () async {
                        user.phoneNum = _userPhoneNumController.text;
                        setState(() {
                          _userPhoneNumController.text = user.phoneNum;
                        });
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
                            .setData(user.toJson(), merge:true);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _userEditBottomSheetICNum(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height * .80,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Update Profile"),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.orange,
                      iconSize: 25,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _userICnumController,
                          decoration: InputDecoration(
                            helperText: "Input IC Number",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Save'),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () async {
                        user.ICnum = _userICnumController.text;
                        setState(() {
                          _userICnumController.text = user.ICnum;
                        });
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
                            .setData(user.toJson(), merge:true);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _userEditBottomSheetAddress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height * .80,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Update Address"),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.orange,
                      iconSize: 25,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _userAddressController,
                          decoration: InputDecoration(
                            helperText: "New Address",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Save'),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () async {
                        user.address = _userAddressController.text;
                        setState(() {
                          _userAddressController.text = user.address;
                        });
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
                            .setData(user.toJson(), merge:true);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _changePassword(BuildContext context) async{
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height * .80,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Update Password"),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.cancel),
                        color: Colors.orange,
                        iconSize: 25,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: TextField(
                            obscureText: true,
                            controller: _userPasswordController,
                            decoration: InputDecoration(
                              helperText: "New Password",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Save'),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () async {
                          var password = _userPasswordController.text;
                          setState(() {
                            _userPasswordController.text = password;
                          });
                          FirebaseUser users = await FirebaseAuth.instance.currentUser();
                          users.updatePassword(password).then((_){
                            print("Succesfull changed password");
                            Navigator.of(context).pop();
                          }).catchError((error){
                            print("Password can't be changed" + error.toString());
                            //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                          }
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
