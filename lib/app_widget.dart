import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funandmoving/UI/Client/ActivationScreen.dart';
import 'UI/Client/BaseLayer.dart';
import 'UI/Client/Downloads.dart';
import 'UI/Client/Login.dart';
import 'UI/Client/Register.dart';
import 'UI/SplashScreen.dart';
import 'UI/Client/Telemed.dart';
import 'UI/Client/VideoPlayer.dart';
import 'UI/Client/VideosList.dart';
import 'Utils/styles.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: primaryColor
    // ));
    return MaterialApp(
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      onGenerateRoute: (settings){
        if (settings.name == "/videoplayer") {

          final args = settings.arguments as Map;

          return MaterialPageRoute(
            builder: (context) {
              return VideoViewer(url: args["url"],file: args["file"],);
            },
          );
        }
        if (settings.name == "/base") {

          final args = settings.arguments as Map;

          return MaterialPageRoute(
            builder: (context) {
              return BaseLayer(title:args["title"],question:args["question"],data:args["data"],logo:args["logo"],nickname:args["nickname"]);
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      routes: {
        '/': (context) => SplashScreen(),
        '/videos': (context) => VideosList(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/telemed': (context) => Telemed(),
        '/downloads': (context) => Downloads(),
        '/videoplayer': (context) => VideoViewer(),
        '/base': (context) => BaseLayer(),
        '/device': (context) => ActivationScreen()
      },
    );
  }
}
