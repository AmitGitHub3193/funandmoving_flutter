import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:funandmoving/Models/QuestionModel.dart';
import 'package:funandmoving/Models/SelectionModel.dart';
import 'package:funandmoving/Models/VideosModel.dart';
import 'package:funandmoving/Services/Services.dart';
import 'package:funandmoving/SharedWidgets/CustomBottomBar.dart';
import 'package:funandmoving/SharedWidgets/CustomButton.dart';
import 'package:funandmoving/SharedWidgets/MyText.dart';
import 'package:funandmoving/SharedWidgets/VideoTile.dart';
import 'package:funandmoving/Utils/colors.dart';

class VideosList extends StatefulWidget {
  const VideosList({Key? key}) : super(key: key);

  @override
  _VideosListState createState() => _VideosListState();
}

class _VideosListState extends State<VideosList> with WidgetsBindingObserver {
  Services service = Services();
  SelectionModel selected = SelectionModel();

  List<Videos> videos = [];
  List<Selections> tabs = [];
  List<Selections> intensities = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Theme.of(context).primaryColor));

    setState(() {
      tabs = service.exercise.selections!
          .where((element) =>
              element.classId == int.parse(selected.videoClass.id!))
          .toList();
      print(tabs.length);
      intensities = service.intensity.selections!
          .where((element) => element.classId == selected.exercise.classId)
          .toList();
    });
    service.videos.videos!.forEach((element) {
      if (element.intensity == selected.intensity.name &&
          element.exercise == selected.exercise.name &&
          element.videoClass == selected.videoClass.name) {
        setState(() {
          videos.add(element);
        });
      }
    });
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {});
      print('After Orientation Change: ');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Theme.of(context).primaryColor));

    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(0),
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 75,
                  width: size.width,
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   height: 40,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal:8.0),
                      //   child: GestureDetector(
                      //     child: Icon(
                      //       Icons.arrow_back,
                      //       color: Colors.white,
                      //     ),
                      //     onTap: () {
                      //       Modular.to.pop(context);
                      //     },
                      //   ),
                      // ),
                      Expanded(
                        child: Center(
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selected.exercise = tabs[index];
                                          videos.clear();
                                          service.videos.videos!
                                              .forEach((element) {
                                            if (element.intensity ==
                                                    selected.intensity.name &&
                                                element.exercise ==
                                                    selected.exercise.name &&
                                                element.videoClass ==
                                                    selected.videoClass.name) {
                                              setState(() {
                                                videos.add(element);
                                              });
                                            }
                                          });
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: MyText(
                                            title: tabs[index].nickname,
                                            clr: selected.exercise.nickname ==
                                                    tabs[index].nickname
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.7),
                                            size: Device.get().isTablet == true
                                                ? 17
                                                : 15,
                                            weight: "Semi Bold"),
                                      )),
                                );
                              },
                              separatorBuilder: (ctx, index) {
                                return SizedBox(
                                  width: 8,
                                );
                              },
                              itemCount: tabs.length),
                        ),
                      ),
                      // SizedBox(height: 15,)
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 5),
                    child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Wrap(
                              runSpacing: Device.get().isTablet ? 30 : 10.0,
                              spacing: 10.0,
                              alignment: WrapAlignment.center,
                              children: List.generate(
                                videos.length,
                                (index) {
                                  return VideoTile(
                                    video: videos[index],
                                    backStatus: (val) {
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: Device.get().isTablet ? 50 : 10,
                                  top: 5),
                              child: MainButton(
                                  label: "HOME",
                                  width: 100,
                                  height: 35,
                                  action: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
            Container(
              width: 40,
              alignment: Alignment.centerLeft,
              child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected.intensity = intensities[index];
                          videos.clear();
                          service.videos.videos!.forEach((element) {
                            if (element.intensity == selected.intensity.name &&
                                element.exercise == selected.exercise.name &&
                                element.videoClass ==
                                    selected.videoClass.name) {
                              setState(() {
                                videos.add(element);
                              });
                            }
                          });
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              selected.intensity.name == intensities[index].name
                                  ? colorConvert(intensities[index].color!)
                                  : Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0)),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: selected.intensity.name ==
                          //             intensities[index].name
                          //         ? colorConvert(intensities[index].color!)
                          //         : Colors.grey[300]!,
                          //     spreadRadius: 1,
                          //     blurRadius: 10,
                          //     offset:
                          //         Offset(0, 0), // changes position of shadow
                          //   ),
                          //   BoxShadow(
                          //     color: selected.intensity.name ==
                          //             intensities[index].name
                          //         ? colorConvert(intensities[index].color!)
                          //         : Colors.grey[300]!,
                          //     spreadRadius: 1,
                          //     blurRadius: 10,
                          //     offset:
                          //         Offset(0, 0), // changes position of shadow
                          //   ),
                          // ],
                        ),
                        child: Center(
                          child: Image(
                              color: Colors.black,
                              image: NetworkImage(selected.intensity.id ==
                                      intensities[index].id
                                  ? intensities[index].selectedThumbnail!
                                  : intensities[index].unselectedThumbnail!)),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: intensities.length),
            )
          ],
        ),
      ),
    );
  }
}
