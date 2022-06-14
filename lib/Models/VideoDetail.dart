
class VideoDetail {
  String? id;
  String? name;
  String? image;
  String? streamUrl;
  String? downloadUrl;
  String? classs;
  String? exercise;
  String? intensity;
  String? trainerName;
  String? verified;
  String? status;

  VideoDetail({this.id, this.name, this.image, this.streamUrl, this.downloadUrl, this.classs, this.exercise, this.intensity, this.trainerName, this.verified, this.status});

  VideoDetail.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  image = json['image'];
  streamUrl = json['stream_url'];
  downloadUrl = json['download_url'];
  classs = json['class'];
  exercise = json['exercise'];
  intensity = json['intensity'];
  trainerName = json['trainer_name'];
  verified = json['verified'];
  status = json['status'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['name'] = this.name;
  data['image'] = this.image;
  data['stream_url'] = this.streamUrl;
  data['download_url'] = this.downloadUrl;
  data['class'] = this.classs;
  data['exercise'] = this.exercise;
  data['intensity'] = this.intensity;
  data['trainer_name'] = this.trainerName;
  data['verified'] = this.verified;
  data['status'] = this.status;
  return data;
  }
}