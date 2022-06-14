import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:funandmoving/Services/APIConstants.dart';
import 'package:funandmoving/Services/Services.dart';
import 'package:funandmoving/SharedWidgets/AuthTextField.dart';
import 'package:funandmoving/SharedWidgets/CustomBottomBar.dart';
import 'package:funandmoving/SharedWidgets/MyText.dart';
import 'package:funandmoving/SharedWidgets/StaggerAnimation.dart';
import 'package:funandmoving/UI/Client/Register.dart';
import 'package:funandmoving/Utils/images.dart';

class LoginScreen extends StatefulWidget {
  final bool fromMainPage;
  final Function? onLoginSuccess;

  LoginScreen({this.fromMainPage = false, this.onLoginSuccess});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool passwordShow = true;
  bool isLoading = false;
  late AnimationController _loginButtonController;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  Services services=new Services();

  @override
  Future<void> afterFirstLayout(BuildContext context) async {}

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);

    if (isDevelopmentMode) {
      email.text = "joshua@hayworthsoftware.com";
      password.text = "4TSK8KoMoxsrAaFYvxA6";
    }
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final appModel = Provider.of<AppModel>(context);
    final screenSize = MediaQuery.of(context).size;
    //String subscribeUrl = sServerConfig["subscribe"];
    var theme = Theme.of(context);
    //FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    var userIconSize = 25.0;
    var lockIconSize = 40.0;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: CustomBottomBar(3),
      appBar: AppBar(
        leading: widget.fromMainPage
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
            : Container(),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Builder(

          builder: (context) => GestureDetector(
            //onTap: () => Utils.hideKeyboard(context),
            child: Container(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: Device.get().isTablet ? 60.0 : 18.0),
                child: Container(
                  width: screenSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: screenSize.width *
                            (Device.get().isTablet ? 0.5 : 0.6),
                        child: Image.asset(
                          sLandingImg,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                        child: Text(
                          "Let's Get Started",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: Device.get().isTablet ? 30 : 25),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(height: 20),
                      AuthInput(
                          controller: email,
                          label: 'User',
                          icon: user,
                          sizeIcon: userIconSize),
                      SizedBox(height: Device.get().isTablet ? 30 : 15.0),
                      AuthInput(
                          controller: password,
                          label: 'Password',
                          icon: lock,
                          sizeIcon: lockIconSize,
                          isForPwd: true),
                      SizedBox(height: Device.get().isTablet ? 50 : 40),
                      StaggerAnimation(
                        titleButton: "CONTINUE",
                        buttonController: _loginButtonController.view as AnimationController,
                        onTap: () {
                          if (!isLoading) {
                            _login(context);
                          }
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        // child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       "Need to Subscribe? ",
                        //       style: TextStyle(
                        //           fontSize: 18,
                        //           color: theme.primaryColor),
                        //     ),
                        //     Text(
                        //       "Click Here",
                        //       style: TextStyle(
                        //           fontSize: 18,
                        //           decoration: TextDecoration.underline,
                        //           color: theme.primaryColor),
                        //     )
                        //   ],
                        // ),
                        child: MyText(title: "Activate new Account",size: 18,under: true,),
                        onTap: () {
                          Navigator.pushNamed(context, "/device");
                          // Navigator.push(context,MaterialPageRoute(
                          //     builder: (BuildContext context) => RegisterScreen()
                          // )
                          // );
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {
      print('[_playAnimation] error');
    }
  }

  void _welcomeMessage(user, context) {
    if (widget.onLoginSuccess != null) {
      widget.onLoginSuccess!(context);
    } else {
      Navigator.of(context).pop(user);
    }
  }

  void _failMessage(message, context) {
    /// Showing Error messageSnackBarDemo
    /// Ability so close message
    final snackBar = SnackBar(
      content: Text("LogIn failed, $message"),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: "Close",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<Null> _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      print('[_stopAnimation] error');
    }
  }

  _login(context) async {
    if (email.text.isEmpty || password.text.isEmpty) {
      var snackBar = SnackBar(
        content: Text("Please fill all fields"),
        duration: Duration(seconds: 2),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else if (Validator.validateEmail(email.text) != null) {
      //MARK:
      var snackBar = SnackBar(
        content: Text(Validator.validateEmail(email.text)!),
        duration: Duration(seconds: 2),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      await _playAnimation();
      await services.login(
        context,
        email: email.text.trim(),
        password: password.text.trim()
        // success: (user) {
        //   log("sucess");
        //   _stopAnimation();
        //   _welcomeMessage(user, context);
        // },
        // fail: (message) {
        //   log("failed");
        //   _stopAnimation();
        //   _failMessage(message, context);
        // },
      );
      _stopAnimation();
    }
  }
}

class Validator {
  static String? validateEmail(String value) {
    try {
      bool valid= RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
      if(valid){
        return null;
      }else{
        return 'The E-mail Address must be a valid email address.';
      }
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }
}