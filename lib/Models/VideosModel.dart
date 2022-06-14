import 'dart:io';

import 'package:funandmoving/Services/Services.dart';

import 'QuestionModel.dart';

class VideosModel {
  List<Videos>? videos;

  VideosModel({this.videos});

  VideosModel.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) { videos!.add(new Videos.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  String? id;
  String? name;
  String? type;
  String? tagline;
  String? description;
  String? image;
  String? mediaLink;
  String? mediaLength;
  String? videoClass;
  String? exercise;
  String? intensity;
  String? trainerName;

  Videos({this.id, this.name, this.type, this.tagline, this.description, this.image, this.mediaLink, this.mediaLength, this.videoClass, this.exercise, this.intensity, this.trainerName});

  Videos.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  type = json['type'];
  tagline = json['tagline'];
  description = json['description'];
  image = json['image'];
  mediaLink = json['media_link'];
  mediaLength = json['media_length'];
  videoClass = json['class'];
  exercise = json['exercise'];
  intensity = json['intensity'];
  trainerName = json['trainer_name'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['name'] = this.name;
  data['type'] = this.type;
  data['tagline'] = this.tagline;
  data['description'] = this.description;
  data['image'] = this.image;
  data['media_link'] = this.mediaLink;
  data['media_length'] = this.mediaLength;
  data['class'] = this.videoClass;
  data['exercise'] = this.exercise;
  data['intensity'] = this.intensity;
  data['trainer_name'] = this.trainerName;
  return data;
  }
}

class UploadVideoModel {
  File? file;
  String? trainerName;
  String? sessionId;
  String? videoTitle;
  Selections? videoCategory;
  Selections? videoIntensity;
  Selections? videoClass;

  UploadVideoModel.init(
      {File? file,
        String? trainerName,
        String? sessionId,
        String? videoTitle,
        Selections? videoCategory,
        Selections? videoIntensity,
        Selections? videoClass}) {
    this.file = file;
    this.trainerName = trainerName;
    this.sessionId = sessionId;
    this.videoTitle = videoTitle;
    this.videoCategory = videoCategory;
    this.videoIntensity = videoIntensity;
    this.videoClass = videoClass;
  }

  Map toJson(){
    return {
      "file":file!.path,
      "trainerName":trainerName,
      "sessionId":sessionId,
      "videoTitle":videoTitle,
      "videoCategory":videoCategory!.toJson(),
      "videoIntensity":videoIntensity!.toJson(),
      "videoClass":videoClass!.toJson()
    };
  }


}

class UploadVideo{

  bool isLoading = true;
  final Services _service = Services();
  double progress = 0.0;
  bool compressingCompleted = false;

  Future<void> uploadVideo(UploadVideoModel video,context,
      {Function? success,
        Function? fail,
        Function(double percent, String bytesRatio)? uploadingProgress}) async {
    try {
      isLoading = true;
      //notifyListeners();
      bool result = await _service.uploadVideo(video,context,
          uploadingProgress: uploadingProgress!);
      print(result);
      success!(result);
      isLoading = false;
      success(result);
      //notifyListeners();
    } catch (err) {
      isLoading = false;
      //notifyListeners();
      fail!(err.toString());
      print(err.toString());
    }
  }
}