import '../Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import 'CustomImage.dart';
import 'MyText.dart';

class ChoiceTile extends StatelessWidget {
  final select;
  Function? tapped, tapping, tappingCancel;
  final bool? isTapping,nickname;
  final Color? color;

  ChoiceTile(
      {Key? key,
        required this.select,
        this.nickname,
        this.isTapping,
        this.tapped,
        this.tappingCancel,
        this.tapping,this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = Device.get().isTablet ? 200.0 : 130.0;
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: tapped as void Function()?,
      onTapDown: (detail) {
        tapping!();
      },
      onTapUp: (detail) {
        tappingCancel!();
      },
      onTapCancel: () {
        tappingCancel!();
      },
      child: Container(
        width: size,
        child: Center(
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: color==null?theme.primaryColor:color!, width: 1.6),
              color: isTapping!
                  ? theme.primaryColor.withOpacity(0.5)
                  : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: color==null?theme.primaryColor.withAlpha(200).withOpacity(0.7):color!.withAlpha(200).withOpacity(0.7),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  width: size * 0.4,
                  height: size * 0.4,
                  child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(size * 0.25)),
                      child: isTapping!
                          ? CustomImage(
                          select.selectedThumbnail, false,null,null,false)
                          : CustomImage(
                          select.unselectedThumbnail, false,null,null,false)),
                ),
                Container(
                  width: size * 0.85,
                  padding: EdgeInsets.only(bottom: 0),
                  child: Center(
                    child: Container(
                      height: 60,
                      child: Center(
                        child: MyText(
                          title:nickname==true?select.nickname:
                          select.name,
                          line: 2,
                          toverflow: TextOverflow.ellipsis,
                          center: true,
                          size: Device.get().isTablet ? 18 : 16,
                            clr: isTapping!
                                ? theme.backgroundColor
                                : primaryDark
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class AppChoiceTile extends StatelessWidget {
  Function? tapped, tapping, tappingCancel;
  final bool? isTapping;
  final String title;
  final Color? color;

  AppChoiceTile(
      {Key? key,
        required this.title,
        this.isTapping,
        this.tapped,
        this.tappingCancel,
        this.tapping,this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = Device.get().isTablet ? 200.0 : 130.0;
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: tapped as void Function()?,
      onTapDown: (detail) {
        tapping!();
      },
      onTapUp: (detail) {
        tappingCancel!();
      },
      onTapCancel: () {
        tappingCancel!();
      },
      child: Container(
        width: size,
        child: Center(
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: color==null?theme.primaryColor:color!, width: 1.6),
              color: isTapping!
                  ? theme.primaryColor.withOpacity(0.5)
                  : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: color==null?theme.primaryColor.withAlpha(200).withOpacity(0.7):color!.withAlpha(200).withOpacity(0.7),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                // Container(
                //   width: size * 0.4,
                //   height: size * 0.4,
                //   child: ClipRRect(
                //       borderRadius:
                //       BorderRadius.all(Radius.circular(size * 0.25)),
                //       child: isTapping!
                //           ? CustomImage(
                //           select.selectedThumbnail, false,null,null,false)
                //           : CustomImage(
                //           select.unselectedThumbnail, false,null,null,false)),
                // ),
                Container(
                  width: size * 0.85,
                  padding: EdgeInsets.only(bottom: 0),
                  child: Center(
                    child: Container(
                      height: 60,
                      child: Center(
                        child: MyText(
                            title:title,
                            line: 2,
                            toverflow: TextOverflow.ellipsis,
                            center: true,
                            size: Device.get().isTablet ? 18 : 16,
                            clr: isTapping!
                                ? theme.backgroundColor
                                : primaryDark
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}