import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:funandmoving/Models/SelectionModel.dart';
import 'package:funandmoving/Services/Services.dart';
import 'package:funandmoving/SharedWidgets/ChoiceTile.dart';
import 'package:funandmoving/SharedWidgets/CustomBottomBar.dart';
import 'package:funandmoving/SharedWidgets/CustomButton.dart';
import 'package:funandmoving/SharedWidgets/MyText.dart';
import 'package:funandmoving/Utils/TextConstants.dart';
import 'package:funandmoving/Utils/colors.dart';
import 'package:funandmoving/Utils/images.dart';

import 'VideosList.dart';

class BaseLayer extends StatefulWidget {
  String? question, title;
  bool? logo, nickname;
  List? data;

  BaseLayer({this.title, this.question, this.data, this.logo, this.nickname});

  @override
  _BaseLayerState createState() => _BaseLayerState();
}

class _BaseLayerState extends State<BaseLayer> {
  Services service = Services();
  SelectionModel selected = SelectionModel();
  int tappingIndex = -1;
  Map data = {};
  bool authenticated=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    setState(() {});
    service.getLocalData().then((value) {
      setState(() {
        data = value;
      });
    });
    service.authentication(context).then((value) {
      setState(() {
        authenticated=value.authenticated!;
      });
    });
    if (widget.title == "Class") {
      service.getVideos(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(0),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(height: Device.get().isTablet ? 120 : 70),
            Container(
              width: Device.get().isTablet ? 240 : 120,
              child: Image.asset(
                sLandingImg,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: Device.get().isTablet ? 30 : 10),
            MyText(
              title: widget.question ?? "",
              center: true,
              clr: Color(0xff353234),
              size: Device.get().isTablet ? 20 : 18,
            ),
            SizedBox(height: Device.get().isTablet ? 50 : 20),
            Expanded(
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Wrap(
                    runSpacing: Device.get().isTablet ? 30 : 10.0,
                    spacing: 30.0,
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      widget.data!=null?widget.data!.length:0,
                      (index) {
                        return ChoiceTile(
                          color: widget.title! == "Intensity"
                              ? colorConvert(widget.data![index].color)
                              : null,
                          nickname: widget.nickname,
                          select: widget.data![index],
                          isTapping: tappingIndex == index,
                          tapping: () {
                            setState(() {
                              tappingIndex = index;
                            });
                          },
                          tappingCancel: () {
                            setState(() {
                              tappingIndex = -1;
                            });
                          },
                          tapped: () {
                            if (widget.title == "Class") {
                              selected.videoClass = widget.data![index];
                              Navigator.push(context,MaterialPageRoute(
                                  builder: (BuildContext context) => BaseLayer(
                                    title: "Exercise",
                                      question: service.exercise.question,
                                    data: service.exercise.selections!
                                        .where((element) =>
                                    element.classId ==
                                        int.parse(widget.data![index].id))
                                        .toList(),
                                      nickname: true,
                                      logo: true
                                  )
                              )
                              ).then((value) => setState(() {}));
                            }
                            else if (widget.title == "Exercise") {
                              selected.exercise = widget.data![index];

                              Navigator.push(context,MaterialPageRoute(
                                  builder: (BuildContext context) => BaseLayer(
                                      title: "Intensity",
                                      question: service.intensity.question,
                                      data: service.intensity.selections!
                                          .where((element) =>
                                      element.classId ==
                                          widget.data![index].classId)
                                          .toList(),
                                      nickname: false,
                                      logo: true
                                  )
                              )
                              ).then((value) => setState(() {}));
                            }
                            else {
                              selected.intensity = widget.data![index];

                              Navigator.push(context,MaterialPageRoute(
                                  builder: (BuildContext context) => VideosList()
                              )
                              ).then((value) => setState(() {}));
                            }
                          },
                        );
                      },
                    ),
                  )),
            ),
            // Visibility(
            //   visible: widget.title == "Class",
            //   child: Container(
            //     padding: EdgeInsets.only(
            //         bottom: Device.get().isTablet ? 50 : 10, top: 10),
            //     child: MainButton(
            //         label: "Join The FAM!",
            //         action: () {
            //           Navigator.pushNamed(context, "/device");
            //           // if(data[ISLOGIN]!=true) {
            //           //   Navigator.pushNamed(context,"/login");
            //           // }else{
            //           //   service.deleteLocalData().then((value) => setState((){
            //           //     data=value;
            //           //   }));
            //           // }
            //         }),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
