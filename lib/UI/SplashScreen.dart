import 'dart:async';
import 'package:funandmoving/UI/ChoiceScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funandmoving/Services/APIConstants.dart';
import 'package:funandmoving/Services/Services.dart';
import 'package:funandmoving/SharedWidgets/Loading.dart';
import 'package:funandmoving/SharedWidgets/MyText.dart';
import 'package:funandmoving/Utils/InternetConnectivity.dart';
import 'package:funandmoving/Utils/images.dart';
import 'package:open_settings/open_settings.dart';
import '../Utils/TextConstants.dart';
import 'dart:convert';
import '../Models/QuestionModel.dart';
import '../Models/VideosModel.dart';
import 'Client/BaseLayer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<dynamic> showDialogNotInternet(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Center(
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.warning,
                ),
                MyText(title: textConstants.noInternetConnection),
              ],
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: MyText(title: textConstants.pleaseCheckInternet),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                OpenSettings.openWIFISetting();
              },
              child: MyText(title: textConstants.settings),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isDevelopmentMode = true;
    Future.delayed(const Duration(milliseconds: 300), () async {
      // SharedPreferences prefs=await SharedPreferences.getInstance();
      // String ques=prefs.getString(QUESTIONS);
      // String video=prefs.getString(VIDEOS);
      // if(ques!=null && video!=null){
      //   Services service=Services();
      //   Map questions=jsonDecode(ques);
      //   Map videos=jsonDecode(video);
      //   service.intensity=QuestionModel.fromJson(questions["questions"]["intensity"]);
      //   service.exercise=QuestionModel.fromJson(questions["questions"]["exercise"]);
      //   service.videoClass=QuestionModel.fromJson(questions["questions"]["class"]);
      //   service.videos=VideosModel.fromJson(videos);
      //
      //   Future.delayed(Duration(milliseconds: 300),(){
      //     Modular.to.pushReplacementNamed("/base",arguments:{
      //       "title":"Class",
      //       "question":service.videoClass.question,
      //       "data":service.videoClass.selections,
      //       "nickname":false,
      //       "logo":true
      //     });
      //   });
      // }
      // Services().getQuestions(context);

      MyConnectivity.instance.initialise();
      MyConnectivity.instance.myStream.listen((event) async {
        if (MyConnectivity.instance.isIssue(event)) {
          if (MyConnectivity.instance.isShow == false) {
            MyConnectivity.instance.isShow = true;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? ques = prefs.getString(QUESTIONS);
            String? video = prefs.getString(VIDEOS);
            print(ques!.length);
            if (ques != null && video != null) {
              Services service = Services();
              Map questions = jsonDecode(ques);
              Map videos = jsonDecode(video);
              service.intensity =
                  QuestionModel.fromJson(questions["questions"]["intensity"]);
              service.exercise =
                  QuestionModel.fromJson(questions["questions"]["exercise"]);
              service.videoClass =
                  QuestionModel.fromJson(questions["questions"]["class"]);
              service.videos =
                  VideosModel.fromJson(videos as Map<String, dynamic>);

              Future.delayed(Duration(milliseconds: 300), () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => BaseLayer(
                            title: "Class",
                            question: service.videoClass.question,
                            data: service.videoClass.selections,
                            nickname: false,
                            logo: true)));
              });
            }
            else {
              showDialogNotInternet(context).then((onValue) {
                MyConnectivity.instance.isShow = false;
              });
            }
          }
        } else {
          if (MyConnectivity.instance.isShow == true) {
            Navigator.of(context).pop();
            MyConnectivity.instance.isShow = false;
          }
          Services().getQuestions(context);
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => ChoiceScreen()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: size.width / 3 * 2.5,
              child: Image.asset(sLandingImg),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Loading(),
        ],
      ),
    );
  }
}
