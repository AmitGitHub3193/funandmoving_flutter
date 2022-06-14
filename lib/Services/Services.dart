import 'dart:developer';
import 'dart:io';
import 'package:funandmoving/Models/AuthenticationModel.dart';
import 'package:funandmoving/Models/RegisterDevice.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:funandmoving/Models/QuestionModel.dart';
import 'package:funandmoving/Models/UserModel.dart';
import 'package:funandmoving/Models/VideoDetail.dart';
import 'package:funandmoving/Models/VideosModel.dart';
import 'package:funandmoving/UI/Client/BaseLayer.dart';
import 'package:funandmoving/UI/Trainer/VideoForm.dart';
import 'package:funandmoving/Utils/TextConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'dart:convert';
import 'APIConstants.dart';
import 'BaseService.dart';

class Services {
  static final Services _instance = Services._internal();

  factory Services() {
    return _instance;
  }

  Services._internal();

  BaseService _baseService = BaseService();
  QuestionModel videoClass = QuestionModel();
  QuestionModel exercise = QuestionModel();
  QuestionModel intensity = QuestionModel();
  VideosModel videos = VideosModel();

  Future<Map> getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = {
      ISLOGIN: prefs.getBool(ISLOGIN),
      SESSION: prefs.getString(SESSION),
      USERID: prefs.getString(USERID),
      ISTRAINER: prefs.getBool(ISTRAINER)
    };
    return data;
  }

  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SESSION) != null;
  }

  void setVideo(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List list = jsonDecode(pref.getString(VIDEOLIST) ?? "[]");
    list.add(id);
    pref.setString(VIDEOLIST, jsonEncode(list));
  }

  void removeVideo(String? id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List list = jsonDecode(pref.getString(VIDEOLIST) ?? "[]");
    list.removeWhere((element) => element.toString().contains(id!));
    pref.setString(VIDEOLIST, jsonEncode(list));
  }

  void removeAllVideos() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(VIDEOLIST, jsonEncode("[]"));
  }

  Future<Map> deleteLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(ISLOGIN, false);
    prefs.setString(SESSION, "");
    prefs.setString(USERID, "");
    return getLocalData();
  }

  Future getQuestions(context,{bool isTrainer=false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };

    if (Platform.isAndroid) {
      header.addAll({"X-DeviceType": "Android"});
    }

    if (Platform.isIOS) {
      header.addAll({"X-DeviceType": "ios"});
    }

    Map localData = await getLocalData();
    if (localData[SESSION] != null) {
      header.addAll({"X-SessionID": localData[SESSION]});
    }

    var data =
        await _baseService.baseGetAPI(questionsURL, context, header: header);

    if (data == null) {
      // Navigator.pushNamed(context,"");
    } else {
      log(jsonEncode(data));
      prefs.setString(QUESTIONS, jsonEncode(data));
      intensity = QuestionModel.fromJson(data["questions"]["intensity"]);
      exercise = QuestionModel.fromJson(data["questions"]["exercise"]);
      videoClass = QuestionModel.fromJson(data["questions"]["class"]);

      if(isTrainer==false) {
        Future.delayed(Duration(milliseconds: 300), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      BaseLayer(
                          title: "Class",
                          question: videoClass.question,
                          data: videoClass.selections,
                          nickname: false,
                          logo: true)));
        });
      }
    }
  }

  void getVideos(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };

    if (Platform.isAndroid) {
      header.addAll({"X-DeviceType": "Android"});
    }

    if (Platform.isIOS) {
      header.addAll({"X-DeviceType": "ios"});
    }

    Map localData = await getLocalData();
    if (localData[SESSION] != null) {
      header.addAll({"X-SessionID": localData[SESSION]});
    }

    var data =
        await _baseService.baseGetAPI(videosURL, context, header: header);

    if (data == null) {
    } else {
      prefs.setString(VIDEOS, jsonEncode(data));
      videos = VideosModel.fromJson(data);
    }
  }

  Future<VideoDetail?> getVideoDetail(String id, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var sessionId = pref.getString(SESSION);
    var data = await _baseService
        .baseGetAPI(videoDetailURL + id, context, header: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "X-SessionID": sessionId!,
    });
    // print(data);
    if (data == null) {
      return null;
    } else {
      var detail = VideoDetail.fromJson(data);
      return detail;
    }
  }

  Future<User> login(context,{email, password}) async {

    var parameters = {
      "username": email,
      "password": password
    };
    try {
      var data = await _baseService.basePostAPI("Api/auth", parameters, context);

      var user = User.fromJson(data);
      log(user.toJson().toString());
      if(user.authenticated!) {

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString(SESSION, user.session!);
        pref.setString(USERID, user.iD!);
        pref.setString(MUSE_COLLECTION, user.museCollection!);
        pref.setBool(ISLOGIN, user.authenticated!);
        pref.setBool(ISTRAINER, user.userType=="trainer");

        if(user.userType!="trainer"){
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BaseLayer(
                      title: "Class",
                      question: videoClass.question,
                      data: videoClass.selections,
                      nickname: false,
                      logo: true)));
        }else{
          Navigator.of(context).popUntil((route) => true);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => VideoForm()));
        }
      }
      return user;

    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Future<RegisterDevice> registerDevice(context,body) async {

    try {
      var data = await _baseService.basePostAPI(registerDeviceURL, body, context);

      var device = RegisterDevice.fromJson(data);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString(DEVICE_DETAIL, jsonEncode(data));
      return device;

    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Future<AuthenticationModel> authentication(context) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? temp=pref.getString(DEVICE_DETAIL);

    if(temp==null){
      return AuthenticationModel(authenticated: false);
    }

    try {
      var data = await _baseService.basePostAPI(authenticateDeviceURL, {
        "DeviceID": jsonDecode(temp)["DeviceID"]
      }, context);

      var device = AuthenticationModel.fromJson(data);
      return device;

    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Future<bool> uploadVideo (UploadVideoModel uploadVideoModel,context,
      {Function(double percent, String bytesRatio)? uploadingProgress}) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Video Uploading...',barrierDismissible: true,progressType: ProgressType.valuable);
    try {
      //videoTitle is video description???
      var uri = Uri.parse("https://muse.ai/api/files/upload");
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd.hh.mm.ss').format(now);
      var videoName = "${uploadVideoModel.trainerName}-${uploadVideoModel.videoTitle}-${uploadVideoModel.videoClass!.name}-${uploadVideoModel.videoCategory!.name}-${uploadVideoModel.videoIntensity!.name}-$formattedDate";
      // print(videoName);
      // var request= http.MultipartRequest("POST",uri);
      var request = MultipartRequest(
        "POST",
        uri,
        onProgress: (int bytes, int total) {
          final progress = bytes / total * 100;
          uploadingProgress!(progress, "$bytes/$total");
          pd.update(value: progress.toInt()-1);
        },
      );
      print("here");
      // request.fields["file"] = "untitledVideo.mp4";
      request.headers["Key"] = museAPIKey;

      print(uploadVideoModel.file!.path);

      var multiPartFile =
      await http.MultipartFile.fromPath("file", uploadVideoModel.file!.path,filename: "${videoName}.mp4");
      // multiPartFile.finalize();
      request.files.add(multiPartFile);
      log("uploading started");
      print(multiPartFile.contentType);
      print(multiPartFile.field);
      print(multiPartFile.filename);
      print(multiPartFile.isFinalized);

      final http.Response response =
      await http.Response.fromStream(await request.send());
      print(response.headers);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        final fid = body["fid"] ?? null;
        if (fid != null) {
          await updateVideoInfo(fid, videoName);
          final svid = body["svid"];
          await uploadToServer(svid, uploadVideoModel.sessionId!, uploadVideoModel.videoTitle!, uploadVideoModel.videoCategory!.id!, uploadVideoModel.videoIntensity!.id!, uploadVideoModel.videoClass!.id!);
          log("successfully api callleddddd----> ");
          pd.update(value: 100);
          pd.close();
          return true;
        } else {
          pd.close();
          return false;
        }
      } else {
        pd.close();
        return false;
      }
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  Future<void> updateVideoInfo(String fid, String title) async {


    var url = "https://muse.ai/api/files/set/" + fid;
    var parameters = {"visibility": "unlisted", "title": title};
    var headers = {
      "Content-Type": "application/json",
      "Key": museAPIKey
    }; //, "Charset": "utf-8"
    try {
      final http.Response res = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(parameters));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        print(body);
      } else {
        throw Exception("Not Authenticated");
      }
    } catch (err) {
      log(err.toString());
      throw Exception("Not Authenticated");
    }
  }

  Future<void> uploadToServer(String svid, String sessionId, String videoTitle,
      String videoCategory, String videoIntensity, String videoClass) async {
    var url = BaseConfig["url"]! + "Api/addNewVideo";
    var parameters = {
      "muse_svid": svid,
      "video_title": videoTitle,
      "video_category": videoCategory,
      "video_intensity": videoIntensity,
      "video_class": videoClass
    };
    var headers = {
      "X-SessionID": sessionId,
      "Content-Type": "text/plain"
    }; //, "Charset": "utf-8"
    print(parameters);
    try {
      final http.Response res = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(parameters));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        print(body);
      } else {
        throw Exception("Not Authenticated");
      }
    } catch (err) {
      log(err.toString());
      throw Exception("Not Authenticated");
    }
  }
}
