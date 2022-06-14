class RegisterDevice {
  String? deviceID;
  String? shortcode;

  RegisterDevice({this.deviceID, this.shortcode});

  RegisterDevice.fromJson(Map<String, dynamic> json) {
    deviceID = json['DeviceID'];
    shortcode = json['Shortcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DeviceID'] = this.deviceID;
    data['Shortcode'] = this.shortcode;
    return data;
  }
}