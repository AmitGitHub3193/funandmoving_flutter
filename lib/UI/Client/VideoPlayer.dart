import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:funandmoving/Services/Services.dart';
import 'package:funandmoving/SharedWidgets/MyText.dart';

import '../../Utils/Debouncer.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:funandmoving/SharedWidgets/Loading.dart';
import 'package:funandmoving/Utils/TextConstants.dart';
import 'package:funandmoving/Utils/colors.dart';
import 'package:funandmoving/Utils/images.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  VideoViewer({this.url, this.file});

  final String? url;
  final File? file;

  @override
  State<StatefulWidget> createState() {
    return _VideoViewerState();
  }
}

class _VideoViewerState extends State<VideoViewer> with WidgetsBindingObserver {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  final String introVideoLinkForiOS =
      'https://cdn.muse.ai/w/eafc78c9bf01e92dabc5fccd6e34445ede39316580490fa1a3e613974dfdc943/videos/hls.m3u8';
  final String introVideoLinkForAndroid =
      'https://cdn.muse.ai/w/eafc78c9bf01e92dabc5fccd6e34445ede39316580490fa1a3e613974dfdc943/videos/dash.mpd';
  bool isHideToolBar = false;
  final _debouncer = Debouncer(milliseconds: 10000);

  @override
  void initState() {
    super.initState();
    setState(() {
      isHideToolBar = true;
    });
    initializePlayer(widget.url, widget.file);
    // initializePlayer(
    //     null, //"https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8",
    //     widget.file);
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
    _videoPlayerController1.dispose();
    _chewieController!.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  Future<void> initializePlayer(String? url, File? file) async {
    if (url != null) {
      _videoPlayerController1 = VideoPlayerController.network(url);
    }
    if (file != null) {
      print(file.path);
      _videoPlayerController1 = VideoPlayerController.file(file);
    }
    await _videoPlayerController1.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: false,
      customControls: Container(),
      materialProgressColors: ChewieProgressColors(
        playedColor: Theme.of(context).primaryColor,
        handleColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.grey,
        bufferedColor: Theme.of(context).primaryColor,
      ),
    );
    if (mounted) {
      setState(() {});
    }
    introVideo();
  }

  introVideo() async {
    Services().getLocalData().then((value) {
      if (widget.url != null) {
        if (value[ISLOGIN] != true &&
            (value[SESSION] != "" || value[SESSION] != null) &&
            (value[USERID] != "" || value[USERID] != null)) {
          Timer.periodic(Duration(seconds: 1), (timer) {
            if (_videoPlayerController1.value.position.inSeconds >= 120) {
              timer.cancel();
              _videoPlayerController1.pause();
              if (Platform.isAndroid) {
                initializePlayer(introVideoLinkForAndroid, null);
              } else {
                initializePlayer(introVideoLinkForiOS, null);
              }
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black54));

    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              isHideToolBar = !isHideToolBar;
              _videoPlayerController1.pause();

              _debouncer.run(
                () {
                  if (mounted)
                    setState(() {
                      isHideToolBar = true;
                    });
                },
              );
            });
          },
          child: Container(
            child: Stack(
              children: [
                Container(
                  color: orientation == Orientation.portrait
                      ? Colors.black54
                      : Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: _chewieController != null &&
                            _chewieController!
                                .videoPlayerController.value.isInitialized
                        ? AspectRatio(
                            aspectRatio:
                                _videoPlayerController1.value.aspectRatio,
                            child: Chewie(
                              controller: _chewieController!,
                            ))
                        : Loading(),
                  ),
                ),
                Visibility(
                  visible: !isHideToolBar,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 95,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 10),
                          margin: EdgeInsets.only(top: 30, left: 18),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              MyText(
                                title: "HOME",
                                clr: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isHideToolBar,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(150),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 55,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 20,
                      ),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 6,
                            child: VideoProgressIndicator(
                              _videoPlayerController1,
                              allowScrubbing: true,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              colors: VideoProgressColors(
                                  bufferedColor: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(150),
                                  playedColor: Theme.of(context).primaryColor,
                                  backgroundColor: Colors.white.withAlpha(50)),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 40,
                                child: GestureDetector(
                                  child: Image.asset(replay),
                                  onTap: () {
                                    _videoPlayerController1
                                        .seekTo(Duration(seconds: 0));
                                    print("replay");
                                  },
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.fast_rewind,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            var current =
                                                _videoPlayerController1
                                                    .value.position.inSeconds;
                                            _videoPlayerController1.seekTo(
                                                Duration(seconds: current - 5));
                                            print("fast-rewind");
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _videoPlayerController1
                                                  .value.isPlaying
                                              ? Icons.pause_circle_filled
                                              : Icons.play_circle_filled,
                                          color: Colors.white,
                                          size: 45,
                                        ),
                                        iconSize: 45,
                                        onPressed: () {
                                          if (mounted)
                                            setState(() {
                                              _videoPlayerController1
                                                      .value.isPlaying
                                                  ? _videoPlayerController1
                                                      .pause()
                                                  : _videoPlayerController1
                                                      .play();
                                            });
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.fast_forward,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            var current =
                                                _videoPlayerController1
                                                    .value.position.inSeconds;
                                            _videoPlayerController1.seekTo(
                                                Duration(seconds: current + 5));
                                            print("fast-forward : $current");
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                width: 40,
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum AppState {
  idle,
  connected,
  mediaLoaded,
  error,
}
