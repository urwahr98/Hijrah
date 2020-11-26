class User {
  String address;
  String name;
  String phoneNum;
  DateTime birthday;
  String ICnum;

  User(this.address, this.name, this.phoneNum, this.birthday, this.ICnum);

  Map<String, dynamic> toJson() => {
    'address': address,
    'name' : name,
    'phoneNum' : phoneNum,
    'birthday' : birthday,
    'ICnum': ICnum,
  };
}