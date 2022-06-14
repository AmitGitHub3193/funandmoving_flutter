import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:funandmoving/Models/QuestionModel.dart';
import 'package:funandmoving/Models/RegisterDevice.dart';
import 'package:funandmoving/Models/VideosModel.dart';
import 'package:funandmoving/Services/Services.dart';
import 'package:funandmoving/SharedWidgets/ChoiceTile.dart';
import 'package:funandmoving/SharedWidgets/MyText.dart';
import 'package:funandmoving/UI/Trainer/Login.dart';
import 'package:funandmoving/UI/Trainer/VideoForm.dart';
import 'package:funandmoving/Utils/TextConstants.dart';
import 'package:funandmoving/Utils/images.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Client/BaseLayer.dart';

class ChoiceScreen extends StatefulWidget {

  @override
  _ChoiceScreenState createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {

  Services services=Services();
  List apps=[
    "Client",
    "Trainer"
  ];

  int tappingIndex = -1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));

    return Scaffold(
      body: Container(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Device.get().isTablet ? 340 : 220,
              child: Image.asset(
                sLandingImg,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: Device.get().isTablet ? 50 : 30),
            MyText(
              title: "How do you want to use this app?",
              center: true,
              clr: Color(0xff353234),
              size: Device.get().isTablet ? 20 : 18,
            ),
            SizedBox(height: Device.get().isTablet ? 50 : 30),
            Wrap(
              runSpacing: Device.get().isTablet ? 30 : 10.0,
              spacing: 30.0,
              alignment: WrapAlignment.center,
              children: List.generate(
                apps.length,
                    (index) {
                  return AppChoiceTile(title: apps[index],isTapping: tappingIndex == index,
                    tapping: () {
                      setState(() {
                        tappingIndex = index;
                      });
                    },
                    tappingCancel: () {
                      setState(() {
                        tappingIndex = -1;
                      });
                    },tapped: () async {
                    if(index==0){
                      Services().getQuestions(context);
                    }else{
                      services.getLocalData().then((value) {
                        if(value[ISLOGIN]==true && value[ISTRAINER]==true){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => LoginScreen()));
                        }else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => VideoForm()));
                        }
                      });
                    }
                    },);
                },
              ),
            ),
            // Visibility(
            //   visible: widget.title == "Class",
            //   child: Container(
            //     padding: EdgeInsets.only(
            //         bottom: Device.get().isTablet ? 50 : 10, top: 10),
            //     child: MainButton(
            //         label: data[ISLOGIN]==true?"Log out":"Join The FAM!",
            //         action: () {
            //           if(data[ISLOGIN]!=true) {
            //             Navigator.pushNamed(context,"/login");
            //           }else{
            //             service.deleteLocalData().then((value) => setState((){
            //               data=value;
            //             }));
            //           }
            //         }),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
