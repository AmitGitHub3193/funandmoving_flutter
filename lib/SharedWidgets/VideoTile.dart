import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:funandmoving/Models/VideoDetail.dart';
import 'package:funandmoving/UI/Client/VideoPlayer.dart';
import 'package:funandmoving/Utils/TextConstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/VideosModel.dart';
import 'package:flutter/material.dart';
import 'package:funandmoving/Services/Services.dart';
import 'package:funandmoving/Utils/colors.dart';
import 'package:funandmoving/Utils/images.dart';
import '../Utils/colors.dart';
import 'CustomImage.dart';
import 'MyText.dart';

class VideoTile extends StatefulWidget {
  Videos video;
  Function(bool)? backStatus;

  VideoTile({Key? key, required this.video, this.backStatus}) : super(key: key);

  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  Services services = Services();
  bool visible = false;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  downloadVideo() async {
    VideoDetail? data =
        await services.getVideoDetail(widget.video.id!, context);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path + "/" + widget.video.name! + ".mp4";
    print(appDocPath);
    print(data == null);
    print(data!.downloadUrl);
    final savedDir = Directory(appDocPath);
    await savedDir.create(recursive: true).then((value) async {
      String? taskId = await FlutterDownloader.enqueue(
        url: data.downloadUrl != null ? data.downloadUrl! : "",
        savedDir: appDocPath,
        fileName: data.name! + ".mp4",
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
      if (taskId != null) {
        print(taskId);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: MyText(
            title: "Downloading started...",
            clr: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ));
        services.setVideo(data.id! + "," + taskId);
        setState(() {
          status = DownloadTaskStatus.enqueued;
        });
      }
    });
  }

  Future task() async {
    List<DownloadTask>? getTasks = await (FlutterDownloader.loadTasks());
    if (getTasks!.length < 10) {
      downloadVideo();
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: MyText(
          title: "You have exceed the downloading limits",
          clr: Colors.white,
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  checkFavorite() async {
    Services().getLocalData().then((value) {
      if (value[ISLOGIN] == true &&
          value[SESSION] != null &&
          value[SESSION] != "") {
        setState(() {
          visible = true;
        });
      }
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    List list = jsonDecode(pref.getString(VIDEOLIST) ?? "[]");
    if (list.contains(widget.video.id)) {
      setState(() {
        status = DownloadTaskStatus.enqueued;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    var videoLength = widget.video.mediaLength!;
    if (videoLength.contains(' ')) {
      final array = videoLength.split(' ');
      var dim = array[1];
      switch (dim) {
        case "minutes":
          dim = "min";
          break;
        case "seconds":
          dim = "sec";
          break;
        case "hours":
          dim = "hr";
          break;
        default:
          break;
      }
      videoLength = array[0] + dim;
    }
    final videoName = "${widget.video.name} - $videoLength";
    final videoIntensity = "${widget.video.intensity}";
    final trainerName = "${widget.video.trainerName}";
    final color = services.intensity.selections!
        .where((element) => element.name == widget.video.intensity)
        .first
        .color!;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final tileHeight = Device.get().isPhone
        ? MediaQuery.of(context).orientation == Orientation.landscape
            ? 110.0
            : 130.0
        : width > 800
            ? (width / 6) - 20
            : 110.0;
    final tileWidth = Device.get().isPhone
        ? MediaQuery.of(context).orientation == Orientation.landscape
            ? 190.0
            : double.maxFinite
        : width > 800
            ? (width / 4) - 20
            : 220.0;

    return GestureDetector(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => VideoViewer(
                        url: widget.video.mediaLink,
                      ))).then((value) => widget.backStatus!(true));
        },
        child: Container(
          height: tileHeight,
          width: tileWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // image: DecorationImage(
            //   image: NetworkImage(widget.video.image),
            //   fit: BoxFit.fill
            // )
          ),
          child: Stack(
            children: [
              CustomImage(
                  widget.video.image, true, tileHeight, tileWidth, true),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Image.asset(
                    play,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                    //height: width>800?(tileHeight*0.4)+20:60,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(15)),
                        color: Colors.black.withOpacity(0.4)),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            right: 5, left: 5, bottom: 5, top: 5),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                videoName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                trainerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              MyText(
                                title: videoIntensity,
                                line: 1,
                                toverflow: TextOverflow.ellipsis,
                                center: true,
                                clr: colorConvert(color),
                                weight: "Semi Bold",
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
              if (visible)
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(status == DownloadTaskStatus.undefined
                        ? Icons.favorite_border_rounded
                        : Icons.favorite),
                    onPressed: () {
                      if (status == DownloadTaskStatus.undefined) {
                        task();
                      }
                    },
                    color: primary,
                    constraints: BoxConstraints(
                      minWidth: 35,
                      minHeight: 35,
                    ),
                    splashRadius: 25,
                  ),
                )
            ],
          ),
        ));
  }
}
