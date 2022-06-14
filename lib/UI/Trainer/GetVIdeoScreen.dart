// import 'dart:developer';
// import 'dart:html';
// import 'dart:io';
//
// import 'package:FunAndMoving/common/styles.dart';
// import 'package:FunAndMoving/common/tools/functions.dart';
// import 'package:FunAndMoving/models/app_model.dart';
// import 'package:FunAndMoving/models/questions/selection.dart';
// import 'package:FunAndMoving/models/user/user_model.dart';
// import 'package:FunAndMoving/models/video.dart';
// import 'package:FunAndMoving/models/video_model.dart';
// import 'package:FunAndMoving/screens/authentication/login.dart';
// import 'package:FunAndMoving/widgets/loading_logo.dart';
// import 'package:after_layout/after_layout.dart';
// import 'package:fam_trainer/Models/QuestionModel.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:video_compress/video_compress.dart';
// import 'package:video_trimmer/video_trimmer.dart';
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:google_sign_in/google_sign_in.dart' as signIn;
//
// import '../../common/constants/general.dart';
//
// class GetVideo extends StatefulWidget {
//   @override
//   _GetVideoState createState() => _GetVideoState();
// }
//
// class _GetVideoState extends State<GetVideo> with AfterLayoutMixin {
//   Trimmer _trimmer = Trimmer();
//
//   double _startValue = 0.0;
//   double _endValue = 0.0;
//
//   bool _isPlaying = false;
//   bool _progressVisibility = false;
//
//   var titleController = TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   List<Selections> exercises = [];
//   String _selectedType;
//   List<Selections> intensities = [];
//   String _selectedIntensity;
//   final _videoModel = VideoModel();
//   String trimmedVideoPath;
//
//   bool uploadingCompleted = true;
//   bool showProgressView = true;
//   double uploadingProgress = 0.0;
//   double compressingProgress = 0.0;
//   bool videoSetting = false;
//   bool isUploading = false;
//   Subscription _subscription;
//
//   List<PlatformFile> _paths;
//   String _fileName = "";
//   String _filePath = "";
//   String _directory;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
//
//     if (isCompressWhenUploading) {
//       _subscription = VideoCompress.compressProgress$.subscribe((progress) {
//         if (progress != 0.0 && progress != 100.0) {
//           setState(() {
//             compressingProgress = progress;
//           });
//         }
//       });
//     }
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     this.titleController.dispose();
//     if (isCompressWhenUploading) {
//       _subscription.unsubscribe();
//     }
//     super.dispose();
//   }
//
//   Future<String> _saveVideo() async {
//     if (this.mounted) {
//       setState(() {
//         _progressVisibility = true;
//       });
//     }
//
//     String _value;
//
//     await _trimmer
//         .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
//         .then(
//           (value) {
//         if (this.mounted) {
//           setState(
//                 () {
//               _progressVisibility = false;
//               _value = value;
//               trimmedVideoPath = value;
//             },
//           );
//         }
//       },
//     );
//
//     return _value;
//   }
//
//   uploadVideo() async {
//     if (_selectedType == null) {
//       final snackBar = SnackBar(content: Text('Please choose workout type'));
//       Scaffold.of(_scaffoldKey.currentContext).showSnackBar(snackBar);
//
//       //_scaffoldKey.currentState.showSnackBar(snackBar);
//       return;
//     }
//     if (_selectedIntensity == null) {
//       final snackBar = SnackBar(content: Text('Please choose intensity type'));
//       _scaffoldKey.currentState.showSnackBar(snackBar);
//       return;
//     }
//
//     if (titleController.text == null || titleController.text == "") {
//       final snackBar = SnackBar(content: Text('Please enter video title'));
//       _scaffoldKey.currentState.showSnackBar(snackBar);
//       return;
//     }
//
//     File file;
//
//     if (trimmedVideoPath != null) {
//       var uri = Uri.parse(trimmedVideoPath);
//       file = File.fromUri(uri);
//     } else {
//       file = _trimmer.getVideoFile();
//     }
//
//     var _filePath = file.path;
//     setState(() {
//       uploadingCompleted = false;
//       showProgressView = false;
//       uploadingProgress = 0.0;
//     });
//
//     if (isCompressWhenUploading) {
//       final info = await VideoCompress.compressVideo(
//         _filePath,
//         quality: VideoQuality.HighestQuality,
//         deleteOrigin: false,
//         includeAudio: true,
//         frameRate: 30,
//       );
//       file = info.file;
//     }
//
//     setState(() {
//       compressingProgress = 100.0;
//     });
//
//     String sessionId =
//         Provider.of<UserModel>(context, listen: false).user.session ?? "";
//     String videoTitle = titleController.text;
//
//     var videoCategory = exercises
//         .where((element) {
//       return element.name == _selectedType;
//     })
//         .toList()
//         .first;
//
//     var videoIntensity = intensities
//         .where((element) {
//       return element.name == _selectedIntensity;
//     })
//         .toList()
//         .first;
//
//     var uploadVideo = UploadVideoModel.init(
//         file: file,
//         trainerName: sessionId,
//         sessionId: sessionId,
//         videoTitle: videoTitle,
//         videoCategory: videoCategory,
//         videoIntensity: videoIntensity);
//
//     isUploading = true;
//
//     Provider.of<VideoModel>(context, listen: false).uploadVideo(
//       uploadVideo,
//       success: (resultBool) async {
//         if (resultBool) {
//           if (this.mounted) {
//             setState(() {
//               isUploading = false;
//               uploadingCompleted = true;
//               showProgressView = true;
//               titleController.text = "";
//               final snackBar =
//               SnackBar(content: Text('Video Uploaded successfully'));
//               _scaffoldKey.currentState.showSnackBar(snackBar);
//             });
//             if (isCompressWhenUploading) {
//               file.delete();
//             }
//           }
//         } else {
//           if (this.mounted) {
//             setState(() {
//               isUploading = false;
//               uploadingCompleted = true;
//               showProgressView = true;
//               final snackBar =
//               SnackBar(content: Text('Video uploading failed'));
//               _scaffoldKey.currentState.showSnackBar(snackBar);
//             });
//             if (isCompressWhenUploading) {
//               file.delete();
//             }
//           }
//         }
//         print(resultBool);
//       },
//       fail: () async {
//         if (this.mounted) {
//           setState(() {
//             isUploading = true;
//             uploadingCompleted = true;
//             showProgressView = true;
//             uploadingProgress = 0;
//             videoSetting = false;
//           });
//           if (isCompressWhenUploading) {
//             file.delete();
//           }
//         }
//
//         print("fail");
//       },
//       uploadingProgress: (double percent, String bytesRatio) {
//         if (this.mounted) {
//           setState(() {
//             uploadingCompleted = false;
//             //showProgressView = false;
//             uploadingProgress = percent;
//             videoSetting = false;
//           });
//         }
//
//         print(percent);
//         print(bytesRatio);
//       },
//     );
//   }
//
//   Future<void> _showUploadDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           actionsOverflowDirection: VerticalDirection.down,
//           title: Center(
//             child: Text(
//               'Are you sure you will upload this video?',
//               textAlign: TextAlign.center,
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 SizedBox(height: 10),
//                 TextButton(
//                   child: Text('Upload to FAM'),
//                   onPressed: () {
//                     uploadVideo();
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 TextButton(
//                   child: Text('Cancel'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget selectVideoBtn() {
//     return GestureDetector(
//       onTap: () async {
//         _fileName = "";
//         _filePath = "";
//         final googleSignIn =
//         signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
//         final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
//         googleSignIn.signOut();
//         if (account != null) {
//           await _openFileExplorer();
//           log(_fileName);
//           log(_filePath);
//           if (_filePath == "") {
//             return;
//           }
//           var uri = Uri.parse(_filePath);
//           var pickedFile = File.fromUri(uri);
//           if (pickedFile != null) {
//             await _trimmer.loadVideo(videoFile: pickedFile);
//             setState(() {});
//           }
//         }
//       },
//       child: Container(
//         height: 40,
//         margin: EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 5),
//         alignment: FractionalOffset.center,
//         decoration: mainActionButtonDecoration(context),
//         child: Text(
//           "Select Video",
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 19.0,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.2,
//           ),
//         ),
//       ),
//     );
//   }
//
//   _openFileExplorer() async {
//     try {
//       if (_paths != null) _paths.clear();
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           });
//       _paths = (await FilePicker.platform.pickFiles(
//         type: FileType.video,
//         allowMultiple: false,
//         allowedExtensions: null,
//       ))
//           ?.files;
//     } on PlatformException catch (e) {
//       print("Unsupported operation" + e.toString());
//     } catch (ex) {
//       print(ex);
//     }
//     Navigator.pop(context);
//     if (!mounted) return;
//     //setState(() {
//     _fileName = _paths != null ? _paths.map((e) => e.name).toString() : "";
//     _filePath = _paths != null ? _paths.first.path : "";
//     //});
//   }
//
//   Widget trimVideoBtn() {
//     return GestureDetector(
//       onTap: _progressVisibility
//           ? null
//           : () async {
//         print(" endvalue $_endValue");
//         _saveVideo().then((outputPath) {
//           log('OUTPUT PATH: $outputPath');
//
//           final snackBar =
//           SnackBar(content: Text('Video trimmed successfully'));
//           _scaffoldKey.currentState.showSnackBar(snackBar);
//         });
//       },
//       child: Container(
//         height: 40,
//         margin: EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 5),
//         alignment: FractionalOffset.center,
//         decoration: mainActionButtonDecoration(context),
//         child: Text(
//           "Trim Video",
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 19.0,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.2,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget uploadVideoBtn() {
//     return GestureDetector(
//       onTap: () async {
//         _showUploadDialog();
//         return;
//       },
//       child: Container(
//         height: 40,
//         margin: EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 5),
//         alignment: FractionalOffset.center,
//         decoration: mainActionButtonDecoration(context),
//         child: Text(
//           "Upload to FAM",
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 19.0,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.2,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget doneBtn() {
//     return GestureDetector(
//       onTap: () {
//         printLog("Done");
//         setState(() {
//           showProgressView = true;
//           printLog(showProgressView);
//         });
//       },
//       child: Container(
//         height: 40,
//         margin: EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 5),
//         alignment: FractionalOffset.center,
//         decoration: mainActionButtonDecoration(context),
//         child: Text(
//           "Done",
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 19.0,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.2,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget logoff() {
//     return GestureDetector(
//       onTap: () async {
//         if (VideoCompress.isCompressing) {
//           _scaffoldKey.currentState.showSnackBar(
//             SnackBar(
//               content: Text("Please try after current thread is finished"),
//             ),
//           );
//           return;
//         }
//
//         final googleSignIn = signIn.GoogleSignIn.standard();
//         googleSignIn.signOut();
//         _filePath = '';
//         isCompressWhenUploading = false;
//         Provider.of<UserModel>(context, listen: false).deleteUser();
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LoginScreen(fromMainPage: false),
//           ),
//         );
//       },
//       child: Container(
//         height: 40,
//         margin: EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 5),
//         alignment: FractionalOffset.center,
//         decoration: mainActionButtonDecoration(context),
//         child: Text(
//           "Log Out",
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 19.0,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.2,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget workoutType() {
//     List<DropdownMenuItem> items = [];
//     for (var i = 0; i < exercises.length; i++) {
//       items.add(
//         DropdownMenuItem(
//           //child: Expanded(
//           child: Text(exercises[i].name),
//           //  ),
//           value: exercises[i].name,
//         ),
//       );
//     }
//
//     return DropdownButton(
//       isExpanded: true,
//       hint: const Text('Workout Type'),
//       iconSize: 30,
//       icon: Icon(Icons.arrow_drop_down_sharp),
//       value: _selectedType,
//       underline: Container(),
//       items: <DropdownMenuItem>[...items],
//       onChanged: (value) {
//         if (this.mounted) {
//           setState(
//                 () {
//               _selectedType = value;
//             },
//           );
//         }
//       },
//     );
//   }
//
//   Widget workoutTypeDropDown() {
//     return Stack(
//       children: [
//         Container(
//           height: 40,
//           margin: EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 5),
//           padding: EdgeInsets.only(
//             left: 10,
//             right: 10,
//           ),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black45, width: 1),
//             borderRadius: BorderRadius.all(
//               Radius.circular(2),
//             ),
//           ),
//           width: MediaQuery.of(context).size.width,
//           child: workoutType(),
//         ),
//         // Center(
//         //   child: workoutType(),
//         // ),
//       ],
//     );
//   }
//
//   Widget workoutIntensity() {
//     List<DropdownMenuItem> items = [];
//     for (var i = 0; i < intensities.length; i++) {
//       items.add(
//         DropdownMenuItem(
//           child: Text(intensities[i].name),
//           value: intensities[i].name,
//         ),
//       );
//     }
//
//     return DropdownButton(
//       isExpanded: true,
//       hint: const Text('Workout Intensity'),
//       iconSize: 30,
//       icon: Icon(Icons.arrow_drop_down_sharp),
//       value: _selectedIntensity,
//       underline: Container(),
//       items: <DropdownMenuItem>[...items],
//       onChanged: (value) {
//         if (this.mounted) {
//           setState(
//                 () {
//               _selectedIntensity = value;
//             },
//           );
//         }
//       },
//     );
//   }
//
//   Widget workoutIntensityDropDown() {
//     return Stack(
//       children: [
//         Container(
//           height: 40,
//           margin: EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 5),
//           padding: EdgeInsets.only(
//             left: 10,
//             right: 10,
//           ),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black45, width: 1),
//             borderRadius: BorderRadius.all(
//               Radius.circular(2),
//             ),
//           ),
//           width: MediaQuery.of(context).size.width,
//           child: workoutIntensity(),
//         ),
//         // Center(
//         //   child: workoutIntensity(),
//         // ),
//       ],
//     );
//   }
//
//   Widget workoutDescription() {
//     return Container(
//       //height: 60,
//       margin: EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 5),
//       padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black45, width: 1),
//         borderRadius: BorderRadius.all(
//           Radius.circular(2),
//         ),
//       ),
//       width: MediaQuery.of(context).size.width,
//       child: TextField(
//         enabled: true,
//         decoration: InputDecoration(
//             fillColor: Colors.black38,
//             hintText: "Video Title",
//             enabledBorder: InputBorder.none,
//             border: InputBorder.none),
//         controller: titleController,
//         autofocus: false,
//         autocorrect: false,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: theme.backgroundColor,
//       key: _scaffoldKey,
//       // appBar: AppBar(
//       //   title: Text(widget.title),
//       //   backgroundColor: theme.backgroundColor,
//       //   leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: () {
//       //     if (uploadingCompleted) {
//       //       Navigator.of(context).pop();
//       //     }
//       //   },),
//       // ),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraint) {
//             return ListenableProvider.value(
//               value: Provider.of<AppModel>(context),
//               child: Consumer<AppModel>(builder: (context, valueApp, child) {
//                 printLog("showVideoProgreesView $showProgressView");
//                 return ListenableProvider.value(
//                   value: _videoModel,
//                   child: Consumer<VideoModel>(builder: (context, value, child) {
//                     if (valueApp.isLoading) {
//                       return LoadingWithLogo();
//                     } else {
//                       exercises = Provider.of<AppModel>(context, listen: false)
//                           .initialData
//                           .exercise
//                           .exerciseSelections;
//                       intensities =
//                           Provider.of<AppModel>(context, listen: false)
//                               .initialData
//                               .intensity
//                               .exerciseSelections;
//
//                       return SingleChildScrollView(
//                         child: ConstrainedBox(
//                           constraints:
//                           BoxConstraints(minHeight: constraint.maxHeight),
//                           child: IntrinsicHeight(
//                             child: Stack(
//                               children: [
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: <Widget>[
//                                     SizedBox(
//                                       height: 5,
//                                       child:
//                                       Container(color: Colors.transparent),
//                                     ),
//                                     Visibility(
//                                       visible: _progressVisibility ||
//                                           !uploadingCompleted,
//                                       child: LinearProgressIndicator(
//                                         backgroundColor: theme.primaryColor,
//                                       ),
//                                     ),
//                                     SizedBox(height: 20),
//                                     selectVideoBtn(),
//                                     SizedBox(height: 20),
//                                     _filePath != ""
//                                         ? Expanded(
//                                       child: Stack(
//                                         children: [
//                                           Container(
//                                             color: Colors.black,
//                                             child: VideoViewer(),
//                                           ),
//                                           Center(
//                                             child: Container(
//                                               decoration:
//                                               playButtonDecoration(
//                                                   context),
//                                               child: TextButton(
//                                                 child: _isPlaying
//                                                     ? Icon(
//                                                   Icons.pause,
//                                                   size: 60.0,
//                                                   color:
//                                                   Colors.white,
//                                                 )
//                                                     : Icon(
//                                                   Icons.play_arrow,
//                                                   size: 60.0,
//                                                   color:
//                                                   Colors.white,
//                                                 ),
//                                                 onPressed: () async {
//                                                   bool playbackState =
//                                                   await _trimmer
//                                                       .videPlaybackControl(
//                                                     startValue:
//                                                     _startValue,
//                                                     endValue: _endValue,
//                                                   );
//                                                   if (this.mounted) {
//                                                     setState(() {
//                                                       _isPlaying =
//                                                           playbackState;
//                                                     });
//                                                   }
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                         : Container(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 10),
//                                       child: Center(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                           children: [
//                                             Icon(Icons.info),
//                                             SizedBox(width: 10),
//                                             Text(
//                                               "No Video selected",
//                                               style: TextStyle(
//                                                   fontSize: 20,
//                                                   fontWeight:
//                                                   FontWeight.w700),
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     if (_filePath != "")
//                                       Center(
//                                         child: Container(
//                                           color: Colors.black,
//                                           width:
//                                           MediaQuery.of(context).size.width,
//                                           child: TrimEditor(
//                                             viewerHeight: 50.0,
//                                             viewerWidth: MediaQuery.of(context)
//                                                 .size
//                                                 .width,
//                                             circlePaintColor:
//                                             theme.primaryColor,
//                                             borderPaintColor: Colors.white,
//                                             scrubberPaintColor: Colors.green,
//                                             onChangeStart: (value) {
//                                               _startValue = value;
//                                             },
//                                             onChangeEnd: (value) {
//                                               _endValue = value;
//                                             },
//                                             onChangePlaybackState: (value) {
//                                               if (!isUploading) {
//                                                 if (this.mounted) {
//                                                   setState(() {
//                                                     _isPlaying = value;
//                                                   });
//                                                 }
//                                               }
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     if (_filePath != "")
//                                       Container(height: 5, color: Colors.black),
//                                     if (_filePath != "") trimVideoBtn(),
//                                     SizedBox(height: 20),
//                                     workoutTypeDropDown(),
//                                     workoutIntensityDropDown(),
//                                     workoutDescription(),
//                                     uploadVideoBtn(),
//                                     logoff(),
//                                     SizedBox(height: 30),
//                                   ],
//                                 ),
//                                 if (!showProgressView)
//                                   Container(
//                                     padding:
//                                     EdgeInsets.symmetric(horizontal: 50),
//                                     color: Colors.white,
//                                     child: Center(
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                         children: [
//                                           if (isCompressWhenUploading) ...<
//                                               Widget>[
//                                             LinearProgressIndicator(
//                                               backgroundColor: Colors.black26,
//                                               value:
//                                               compressingProgress / 100.0,
//                                             ),
//                                             SizedBox(height: 10),
//                                             Text(
//                                                 "Compressing ${Utils.getFormattedDouble(compressingProgress)}%"),
//                                             SizedBox(height: 20),
//                                           ],
//
//                                           LinearProgressIndicator(
//                                             backgroundColor: Colors.black26,
//                                             value: uploadingProgress / 100.0,
//                                           ),
//                                           SizedBox(height: 10),
//                                           Text(
//                                               "Uploading ${Utils.getFormattedDouble(uploadingProgress)}%"),
//                                           SizedBox(height: 20),
//                                           CircularProgressIndicator(),
//                                           SizedBox(height: 20),
//                                           // videoSetting
//                                           //     ? Text("Setting...")
//                                           //     : Text(
//                                           //         "${Utils.getFormattedDouble(uploadingProgress)}% uploaded"),
//                                           SizedBox(height: 100),
//                                           doneBtn()
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                   }),
//                 );
//               }),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   void afterFirstLayout(BuildContext context) {
//     Provider.of<AppModel>(context, listen: false).getInitialData(
//       success: (initialData) {
//         printLog(initialData.exercise);
//         printLog("success");
//       },
//       fail: (fail) {
//         printLog("failes");
//       },
//     );
//   }
// }
