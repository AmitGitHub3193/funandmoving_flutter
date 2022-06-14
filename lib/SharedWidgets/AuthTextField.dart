
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:funandmoving/Utils/colors.dart';

class AuthInput extends StatefulWidget {
  TextEditingController controller;
  String? label;
  String? icon;
  double? sizeIcon;
  bool isForPwd;

  AuthInput(
      {Key? key,
        required this.controller,
        this.label,
        this.icon,
        this.sizeIcon,
        this.isForPwd = false})
      : super(key: key);
  @override
  AuthInputState createState() => AuthInputState();
}

class AuthInputState extends State<AuthInput> {
  bool isSecure = false;

  @override
  void initState() {
    super.initState();
    isSecure = widget.isForPwd;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                widget.label!,
                style: TextStyle(color: Colors.transparent),
              ),
              TextField(
                controller: widget.controller,
                obscureText: isSecure,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    padding: EdgeInsets.only(bottom: 2),
                    width: 25,
                    child: Center(
                      child: Image.asset(
                        widget.icon!,
                        width: widget.sizeIcon,
                        height: widget.sizeIcon,
                      ),
                    ),
                  ),
                  suffixIcon: widget.isForPwd
                      ? Container(
                    padding: EdgeInsets.only(bottom: 2),
                    width: 25,
                    child: Center(
                      //child: Icon(Icons.email),
                      child: IconButton(
                        icon: Icon(
                          isSecure
                              ? CupertinoIcons.eye_solid
                              : CupertinoIcons.eye_slash_fill,
                          size: 15,
                          color: textFieldBorderUnfocusedColor,
                        ),
                        onPressed: () {
                          setState(
                                () {
                              isSecure = !isSecure;
                            },
                          );
                        },
                      ),
                    ),
                  )
                      : Container(
                    width: 5,
                  ),
                  contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                  fillColor: Theme.of(context).accentColor,
                  hintText: "",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    borderSide:
                    BorderSide(color: theme.primaryColor, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    borderSide: BorderSide(
                        color: textFieldBorderUnfocusedColor, width: 1.0),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5, right: 5, left: 5),
                color: Colors.white,
                child: Text(
                  widget.label!,
                  style: TextStyle(fontSize: 20, color: Color(0xff484848)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
