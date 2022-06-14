import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:funandmoving/Utils/images.dart';
import 'package:http/http.dart' as http;
import 'Loading.dart';

class CustomImage extends StatefulWidget {
  String? url;
  bool isUserProfile;
  final height,width,bg;

  CustomImage(this.url, this.isUserProfile,this.height,this.width,this.bg);

  @override
  _CustomImageState createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  DefaultCacheManager cacheManager = DefaultCacheManager();
  File? file;

  @override
  Widget build(BuildContext context) {
    cacheManager
        .getFile(widget.url!)
        .singleWhere((element) => element.originalUrl == widget.url)
        .then((value) {
          if(mounted) {
            setState(() {
              file = value.file;
            });
          }
        });

    return
      widget.bg==false?
      file != null
        ? Image.file(file!, errorBuilder: (context, object, trace) {
            return widget.isUserProfile
                ? Image.asset(
                    user,
                    fit: BoxFit.contain,
              cacheWidth: widget.width,
              cacheHeight: widget.height,
                  )
                : Center(
                    child: Icon(
                    Icons.error,
                    size: 35,
                      color: widget.url!.contains("unselected")?Colors.black:Colors.white,
                  ));
          })
        : FutureBuilder(
            // Paste your image URL inside the htt.get method as a parameter
            future: http.get(Uri.parse(widget.url!)),
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Press button to start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Loading();
                case ConnectionState.done:
                  cacheManager.putFile(widget.url!, snapshot.data!.bodyBytes);
                  if (snapshot.hasError || snapshot.data!.bodyBytes == null)
                    return widget.isUserProfile
                        ? Image.asset(
                            user,
                            fit: BoxFit.contain,
                      cacheWidth: widget.width,
                      cacheHeight: widget.height,
                          )
                        : Center(
                            child: Icon(
                            Icons.error,
                            size: 35,
                              color: widget.url!.contains("unselected")?Colors.black:Colors.white,
                          ));
                  return Image.memory(
                    snapshot.data!.bodyBytes,
                    fit: BoxFit.fill,
                    cacheWidth: widget.width,
                    cacheHeight: widget.height,
                    height: widget.height,
                    errorBuilder: (context, object, trace) {
                      return widget.isUserProfile
                          ? Image.asset(
                              user,
                              fit: BoxFit.contain,
                        cacheWidth: widget.width,
                        cacheHeight: widget.height,
                            )
                          : Center(
                              child: Icon(
                              Icons.error,
                              size: 35,
                                color: widget.url!.contains("unselected")?Colors.black:Colors.white,
                            ));
                    },
                  );
              }
              return Container(); // unreachable
            },
          ):
      file != null
          ? Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: FileImage(file!),
            fit: BoxFit.fill
          )
        ),
      )
          : FutureBuilder(
        // Paste your image URL inside the htt.get method as a parameter
        future: http.get(Uri.parse(widget.url!)),
        builder:
            (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Loading();
            case ConnectionState.done:
              if (snapshot.hasError || snapshot.data!.bodyBytes == null)
                return widget.isUserProfile
                    ? Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(user),
                          fit: BoxFit.contain
                      )
                  ),
                )
                    : Center(
                    child: Icon(
                      Icons.error,
                      size: 35,
                      color: widget.url!.contains("unselected")?Colors.black:Colors.white,
                    ));
              cacheManager.putFile(widget.url!, snapshot.data!.bodyBytes);
              return Container(
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: MemoryImage(snapshot.data!.bodyBytes),
                        fit: BoxFit.fill,
                      onError: (e,s){
                        widget.isUserProfile
                            ? Container(
                          height: widget.height,
                          width: widget.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(user),
                                  fit: BoxFit.fill
                              )
                          ),
                        )
                            : Center(
                            child: Icon(
                              Icons.error,
                              size: 35,
                              color: widget.url!.contains("unselected")?Colors.black:Colors.white,
                            ));
                      }
                    )
                ),
              );
          }
          return Container(); // unreachable
        },
      );
  }
}
