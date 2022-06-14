
class User {
  bool? authenticated;
  String? session;
  String? iD;
  String? tTL;
  String? museCollection;
  String? userType;

  User(
      {this.authenticated,
        this.session,
        this.iD,
        this.tTL,this.userType,
        this.museCollection});

  User.fromJson(Map<String, dynamic> json) {
    authenticated = json['Authenticated'];
    session = json['Session'];
    iD = json['ID'];
    tTL = json['TTL'];
    museCollection = json['Muse_Collection'];
    userType = json['UserType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Authenticated'] = this.authenticated;
    data['Session'] = this.session;
    data['ID'] = this.iD;
    data['TTL'] = this.tTL;
    data['Muse_Collection'] = this.museCollection;
    data['UserType'] = this.userType;
    return data;
  }
}