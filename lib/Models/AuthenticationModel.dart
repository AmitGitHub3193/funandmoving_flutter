class AuthenticationModel {
  bool? authenticated;
  String? session;
  String? iD;
  String? tTL;
  String? error;

  AuthenticationModel(
      {this.authenticated, this.session, this.iD, this.tTL, this.error});

  AuthenticationModel.fromJson(Map<String, dynamic> json) {
    authenticated = json['Authenticated'];
    session = json['Session'];
    iD = json['ID'];
    tTL = json['TTL'];
    error = json['Error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Authenticated'] = this.authenticated;
    data['Session'] = this.session;
    data['ID'] = this.iD;
    data['TTL'] = this.tTL;
    data['Error'] = this.error;
    return data;
  }
}
