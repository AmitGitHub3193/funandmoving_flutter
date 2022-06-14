import 'dart:developer';
import 'dart:io';

import 'package:funandmoving/Models/VideosModel.dart';
import 'package:funandmoving/UI/Client/BaseLayer.dart';
import 'package:funandmoving/UI/Trainer/Login.dart';

import '../../Models/QuestionModel.dart';
import '../../Models/VideosModel.dart';
import '../../Services/APIConstants.dart';
import '../../Services/Services.dart';
import '../../SharedWidgets/CustomButton.dart';
import '../../SharedWidgets/MyText.dart';
import '../../Utils/CustomDropdown.dart';
import '../../Utils/TextConstants.dart';
import '../../Utils/Utils.dart';
import '../../Utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';

// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:file_picker/file_picker.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoForm extends StatefulWidget {
  @override
  _VideoFormState createState() => _VideoFormState();
}

class _VideoFormState extends State<VideoForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController title = new TextEditingController();

  List<DropdownItem<Selections>> classDropDownMenuItems = [];
  List<DropdownItem<Selections>> typeDropDownMenuItems = [];
  List<DropdownItem<Selections>> intensityDropDownMenuItems = [];
  late Selections selectedClass, selectedType, selectedIntensity;
  Services services = Services();

  Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;
  late String trimmedVideoPath;

  bool uploadingCompleted = true;
  bool showProgressView = true;
  double uploadingProgress = 0.0;
  double compressingProgress = 0.0;
  bool videoSetting = false;
  bool isUploading = false;
  late Subscription _subscription;

  late List<PlatformFile> _paths;
  String _fileName = "";
  String _filePath = "";
  late String _directory;

  void buildDropDownMenuItems() {
    for (Selections listItem in services.intensity.selections!) {
      setState(() {
        intensityDropDownMenuItems.add(
            DropdownItem(value: listItem,child: Padding(
              padding: const EdgeInsets.symmetric(vertical:4.0),
              child: MyText(
                title:
                listItem.name,
                size: 12,
                clr: Colors.grey[600],
              ),
            ),)
        );
      });
    }

    for (Selections listItem in services.videoClass.selections!) {
      setState(() {
        classDropDownMenuItems.add(DropdownItem(value: listItem,child: Padding(
          padding: const EdgeInsets.symmetric(vertical:4.0),
          child: MyText(
            title:
            listItem.name,
            size: 12,
            clr: Colors.grey[600],
          ),
        ),));
      });
    }

    for (Selections listItem in services.exercise.selections!) {
      setState(() {
        typeDropDownMenuItems.add(
            DropdownItem(value: listItem,child: Padding(
              padding: const EdgeInsets.symmetric(vertical:4.0),
              child: MyText(
                title:
                listItem.name,
                size: 12,
                clr: Colors.grey[600],
              ),
            ),)
        );
      });
    }
  }

  Future<String> _saveVideo() async {
    if (this.mounted) {
      setState(() {
        _progressVisibility = true;
      });
    }

    String? _value;

    await _trimmer
        .saveTrimmedVideo(
            startValue: _startValue,
            endValue: _endValue,
            customVideoFormat: ".mp4")
        .then(
      (value) {
        if (this.mounted) {
          setState(
            () {
              _progressVisibility = false;
              _value = value;
              trimmedVideoPath = value;
            },
          );
        }
      },
    );

    return _value!;
  }

  _openFileExplorer() async {
    try {
      if (_paths != null) _paths.clear();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowCompression: false,
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        _paths=result.files;
        await _trimmer.loadVideo(videoFile: file);
        setState(() {});
      }
      // _paths = (await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowMultiple: false,
      //   allowedExtensions: ["mp4"],
      // ))
      //     ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    Navigator.pop(context);
    if (!mounted) return;
    setState(() {
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : "";
      _filePath = (_paths != null ? _paths.first.path : "")!;
    });
  }

  Widget trimVideoBtn() {
    return GestureDetector(
      // onTap: _progressVisibility
      //     ? null
      //     : () async {
      //   print(" endvalue $_endValue");
      //   _saveVideo().then((outputPath) async {
      //     log('OUTPUT PATH: $outputPath');
      //
      //     // await _trimmer.loadVideo(videoFile: File(trimmedVideoPath));
      //     // setState(() {});
      //
      //     final snackBar =
      //     SnackBar(content: Text('Video trimmed successfully'));
      //     _scaffoldKey.currentState.showSnackBar(snackBar);
      //   });
      // },
      onTap: _progressVisibility
          ? null
          : () async {
              _saveVideo().then((outputPath) async {
                print('OUTPUT PATH: $outputPath');
                // final snackBar =
                // SnackBar(content: Text('Video trimmed successfully'));
                // _scaffoldKey.currentState.showSnackBar(snackBar);
                // await _trimmer.loadVideo(videoFile: File(outputPath));
                // setState(() {});
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => Preview(outputPath),
                //   ),
                // );

              });
            },
      child: Container(
        height: 40,
        margin: EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 5),
        alignment: FractionalOffset.center,
        decoration: mainActionButtonDecoration(context),
        child: Text(
          "Trim Video",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  uploadVideo() async {
    if (selectedClass == null) {
      final snackBar = SnackBar(content: Text('Please choose workout class'));
      _scaffoldKey.currentState!.showSnackBar(snackBar);
      return;
    }
    if (selectedType == null) {
      final snackBar = SnackBar(content: Text('Please choose workout type'));
      _scaffoldKey.currentState!.showSnackBar(snackBar);
      return;
    }
    if (selectedIntensity == null) {
      final snackBar = SnackBar(content: Text('Please choose intensity type'));
      _scaffoldKey.currentState!.showSnackBar(snackBar);
      return;
    }

    if (title.text == null || title.text == "") {
      final snackBar = SnackBar(content: Text('Please enter video title'));
      _scaffoldKey.currentState!.showSnackBar(snackBar);
      return;
    }

    File file;

    if (trimmedVideoPath != null) {
      var uri = Uri.parse(trimmedVideoPath);
      file = File.fromUri(uri);
    } else {
      file = _trimmer.currentVideoFile!;
    }

    var _filePath = file.path;
    setState(() {
      uploadingCompleted = false;
      showProgressView = false;
      uploadingProgress = 0.0;
    });

    if (isCompressWhenUploading) {
      final info = await VideoCompress.compressVideo(
        _filePath,
        quality: VideoQuality.HighestQuality,
        deleteOrigin: false,
        includeAudio: true,
        frameRate: 30,
      );
      file = info!.file!;
    }

    setState(() {
      compressingProgress = 100.0;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(SESSION);
    String videoTitle = title.text;

    isUploading = true;

    var uploadVideo = UploadVideoModel.init(
        file: file,
        trainerName: sessionId,
        sessionId: sessionId,
        videoTitle: videoTitle,
        videoCategory: selectedType,
        videoIntensity: selectedIntensity,
        videoClass: selectedClass);

    log(uploadVideo.toJson().toString());

    UploadVideo().uploadVideo(
      uploadVideo,
      context,
      success: (resultBool) async {
        if (resultBool) {
          if (this.mounted) {
            setState(() {
              isUploading = false;
              uploadingCompleted = true;
              showProgressView = true;
              title.text = "";
              final snackBar =
                  SnackBar(content: Text('Video Uploaded successfully'));
              _scaffoldKey.currentState!.showSnackBar(snackBar);
            });
            if (isCompressWhenUploading) {
              file.delete();
            }
            Future.delayed(Duration(seconds: 1), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => VideoForm()));
            });
          }
        } else {
          if (this.mounted) {
            setState(() {
              isUploading = false;
              uploadingCompleted = true;
              showProgressView = true;
              final snackBar =
                  SnackBar(content: Text('Video uploading failed'));
              _scaffoldKey.currentState!.showSnackBar(snackBar);
            });
            if (isCompressWhenUploading) {
              file.delete();
            }
          }
        }

        print(resultBool);
      },
      fail: () async {
        if (this.mounted) {
          setState(() {
            isUploading = true;
            uploadingCompleted = true;
            showProgressView = true;
            uploadingProgress = 0;
            videoSetting = false;
          });
          if (isCompressWhenUploading) {
            file.delete();
          }
        }

        print("fail");
      },
      uploadingProgress: (double percent, String bytesRatio) {
        if (this.mounted) {
          setState(() {
            uploadingCompleted = false;
            //showProgressView = false;
            uploadingProgress = percent;
            videoSetting = false;
          });
        }

        print(percent);
        print(bytesRatio);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    services.getQuestions(context,isTrainer: true).then((value) {
      buildDropDownMenuItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        body: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  MainButton(
                    label: "Select Video",
                    height: 30,
                    width: double.infinity,
                    action: () async {
                      _fileName = "";
                      _filePath = "";
                      trimmedVideoPath="";
                      // final googleSignIn =
                      // signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
                      // final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
                      // googleSignIn.signOut();
                      // if (account != null) {
                      await _openFileExplorer();
                      // log(_fileName);
                      // log(_filePath);
                      // if (_filePath == "") {
                      //   return;
                      // }
                      // var uri = Uri.parse(_filePath);
                      // var pickedFile = File.fromUri(uri);
                      // if (pickedFile != null) {
                      //   await _trimmer.loadVideo(videoFile: pickedFile,width: MediaQuery.of(context).size.width-30);
                      //   setState(() {});
                      // }
                      // }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _filePath != ""
                      ? Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width - 30,
                              color: Colors.black,
                              child: VideoViewer(trimmer: _trimmer,),
                            ),
                            // Center(
                            //   child: Container(
                            //     decoration:
                            //     playButtonDecoration(
                            //         context),
                            //     child: TextButton(
                            //       child: _isPlaying
                            //           ? Icon(
                            //         Icons.pause,
                            //         size: 60.0,
                            //         color:
                            //         Colors.white,
                            //       )
                            //           : Icon(
                            //         Icons.play_arrow,
                            //         size: 60.0,
                            //         color:
                            //         Colors.white,
                            //       ),
                            //       onPressed: () async {
                            //         bool playbackState =
                            //         await _trimmer
                            //             .videPlaybackControl(
                            //           startValue:
                            //           _startValue,
                            //           endValue: _endValue,
                            //         );
                            //         if (this.mounted) {
                            //           setState(() {
                            //             _isPlaying =
                            //                 playbackState;
                            //           });
                            //         }
                            //       },
                            //     ),
                            //   ),
                            // ),

                            FlatButton(
                              child: _isPlaying
                                  ? Icon(
                                Icons.pause,
                                size: 80.0,
                                color: Colors.white,
                              )
                                  : Icon(
                                Icons.play_arrow,
                                size: 80.0,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                bool playbackState =
                                await _trimmer.videPlaybackControl(
                                  startValue: _startValue,
                                  endValue: _endValue,
                                );
                                setState(() {
                                  _isPlaying = playbackState;
                                });
                              },
                            ),
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info),
                                SizedBox(width: 10),
                                Text(
                                  "No Video selected",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                  // if (_filePath != "" && trimmedVideoPath != "")
                  // Center(
                  //   child: TrimEditor(
                  //     viewerHeight: 50.0,
                  //     viewerWidth: MediaQuery.of(context).size.width,
                  //     maxVideoLength: Duration(seconds: 10),
                  //     onChangeStart: (value) {
                  //       _startValue = value;
                  //     },
                  //     onChangeEnd: (value) {
                  //       _endValue = value;
                  //     },
                  //     onChangePlaybackState: (value) {
                  //       setState(() {
                  //         _isPlaying = value;
                  //       });
                  //     },
                  //   ),
                  // ),


                  if (_filePath != "")
                    Center(
                      child: TrimEditor(
                        durationTextStyle: GoogleFonts.firaSans(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        // maxVideoLength: Duration(seconds: 30),
                        viewerHeight: 50.0,
                        viewerWidth: MediaQuery.of(context).size.width-15,
                        circlePaintColor:
                        Theme.of(context).primaryColor,
                        borderPaintColor: Colors.white,
                        scrubberPaintColor: Colors.green,
                        onChangeStart: (value) {
                          _startValue = value;
                          // setState(() {
                          //
                          // });
                        },
                        onChangeEnd: (value) {
                          _endValue = value;
                          // setState(() {
                          //
                          // });
                        },
                        onChangePlaybackState: (value) {
                          if (!isUploading) {
                            if (this.mounted) {
                              setState(() {
                                _isPlaying = value;
                              });
                            }
                          }
                        }, trimmer: _trimmer,
                      ),
                    ),
                  // if (_filePath != "")
                  //   Container(height: 5, color: Colors.black,width: MediaQuery.of(context).size.width-15,),
                  SizedBox(
                    height: 15,
                  ),
                  if (_filePath != "")
                    MainButton(
                        label: "Trim Video",
                        height: 30,
                        width: double.infinity,
                        action: _progressVisibility
                            ? null
                            : () async {
                                _saveVideo().then((outputPath) async {
                                  print('OUTPUT PATH: $outputPath');
                                  await _trimmer.loadVideo(
                                      videoFile: File(outputPath));
                                  setState(() {});
                                  // Navigator.of(context).pushReplacement(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => Preview(outputPath),
                                  //   ),
                                  // );
                                });
                              }),
                  // trimVideoBtn(),
                  SizedBox(
                    height: 15,
                  ),
                  CustomDropdown<Selections>(
                    child: MyText(
                      title:'Workout Class',
                      size: 12,
                      clr: Colors.grey[600],
                    ),
                    onChange: (Selections value, int index) {
                      setState(() {
                        selectedClass=value;
                      });
                    },
                    dropdownButtonStyle: DropdownButtonStyle(
                      height: 30,
                      elevation: 1,
                      backgroundColor: Colors.white,
                      primaryColor: Colors.grey[600],
                      padding: EdgeInsets.symmetric(horizontal: 8)
                    ),
                    dropdownStyle: DropdownStyle(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 6,
                      padding: EdgeInsets.all(8), offset: Offset.zero, width: double.infinity,
                    ),
                    items: classDropDownMenuItems
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDropdown<Selections>(
                      child: MyText(
                        title:'Workout Type',
                        size: 12,
                        clr: Colors.grey[600],
                      ),
                      onChange: (Selections value, int index) {
                        setState(() {
                          selectedType=value;
                        });
                      },
                      dropdownButtonStyle: DropdownButtonStyle(
                          height: 30,
                          elevation: 1,
                          backgroundColor: Colors.white,
                          primaryColor: Colors.grey[600],
                          padding: EdgeInsets.symmetric(horizontal: 8)
                      ),
                      dropdownStyle: DropdownStyle(
                        borderRadius: BorderRadius.circular(8),
                        elevation: 6,
                        padding: EdgeInsets.all(8), offset: Offset.zero, width: double.infinity,
                      ),
                      items: typeDropDownMenuItems
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDropdown<Selections>(
                      child: MyText(
                        title:'Workout Intensity',
                        size: 12,
                        clr: Colors.grey[600],
                      ),
                      onChange: (Selections value, int index) {
                        setState(() {
                          selectedIntensity=value;
                        });
                      },
                      dropdownButtonStyle: DropdownButtonStyle(
                          height: 30,
                          elevation: 1,
                          backgroundColor: Colors.white,
                          primaryColor: Colors.grey[600],
                          padding: EdgeInsets.symmetric(horizontal: 8)
                      ),
                      dropdownStyle: DropdownStyle(
                        borderRadius: BorderRadius.circular(8),
                        elevation: 6,
                        padding: EdgeInsets.all(8), offset: Offset.zero, width: double.infinity,
                      ),
                      items: intensityDropDownMenuItems
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 30,
                      child: TextField(
                        controller: title,
                        style: GoogleFonts.firaSans(
    fontSize: 14,
    color: Colors.grey[600],
    ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius: BorderRadius.circular(5)),
                            hintText: "Video Title",
                            hintStyle: GoogleFonts.firaSans(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8)),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  MainButton(
                    label: "Upload to FAM",
                    height: 30,
                    width: double.infinity,
                    action: uploadVideo,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MainButton(
                    label: "Log Out",
                    height: 30,
                    width: double.infinity,
                    action: () async {
                      services.deleteLocalData().then((value) {
                        Navigator.of(context).popUntil((route) => true);
                        Navigator.push(context,MaterialPageRoute(
                            builder: (BuildContext context) => BaseLayer(
                                title: "Class",
                                question: services.videoClass.question,
                                data: services.videoClass.selections,
                                nickname: false,
                                logo: true
                            )
                        )
                        );
                      });
                      // SharedPreferences pref =
                      //     await SharedPreferences.getInstance();
                      // pref.clear();
                      // Navigator.popUntil(context,(route) => true);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
