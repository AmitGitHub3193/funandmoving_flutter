// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:funandmoving/UI/Downloads.dart';
// import 'package:funandmoving/UI/Login.dart';
// import 'package:funandmoving/UI/Register.dart';
// import 'package:funandmoving/UI/Telemed.dart';
// import 'package:funandmoving/UI/VideosList.dart';
// import 'UI/BaseLayer.dart';
// import 'UI/SplashScreen.dart';
// import 'UI/VideoPlayer.dart';
// import 'app_widget.dart';
//
// class AppModule extends Module {
//   @override
//   List<Bind> get binds => [];
//
//   @override
//   List<ModularRoute> get routers => [
//     ChildRoute('/', child: (_, __) => SplashScreen()),
//     ChildRoute('/videos', child: (_, __) => VideosList()),
//     ChildRoute('/login', child: (_, __) => LoginScreen()),
//     ChildRoute('/register', child: (_, __) => RegisterScreen()),
//     ChildRoute('/telemed', child: (_, __) => Telemed()),
//     ChildRoute('/downloads', child: (_, __) => Downloads()),
//     ChildRoute('/videoplayer', child: (_, args) => VideoViewer(url: args.data["url"],file: args.data["file"],)),
//     // ChildRoute('/base', child: (_, args) => BaseLayer(args.data["title"],args.data["question"],args.data["data"],args.data["logo"],args.data["nickname"])),
//
//       ];
//
//   @override
//   Widget get bootstrap => AppWidget();
// }
