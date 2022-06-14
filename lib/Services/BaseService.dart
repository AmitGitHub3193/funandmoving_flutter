import 'dart:async';
import 'dart:convert';
import 'package:funandmoving/UI/Client/Login.dart';
import 'APIConstants.dart';
import '../Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../SharedWidgets/MyText.dart';

class BaseService {

  void progressToast(String? msg, bool error,context) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: error ? Colors.red : Theme.of(context).primaryColor,
        gravity: ToastGravity.BOTTOM,
        textColor: Theme.of(context).textSelectionColor);
  }

  Future baseGetAPI(url, context,
      {successMsg,header}) async {

    http.Response response;
    try {
        response = await http.get(
          Uri.parse(BaseConfig["url"]! + url),
          headers: header??<String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );

      print(response.body);

      var jsonData;
      if (response.statusCode == 200) {

        jsonData = json.decode(response.body);
        if (successMsg != null) {
          progressToast(successMsg, false,context);
        }
        return jsonData;
      }
      else if (response.statusCode == 401) {
        jsonData = json.decode(response.body);
        if (jsonData["message"].length != 0) {
          progressToast(jsonData["message"], true,context);
        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        return {};
      }
      else {
        jsonData = json.decode(response.body);
        if (jsonData["message"].length != 0) {
          progressToast(jsonData["message"], true,context);
        }
        return {};
      }
    } catch (SocketException) {
      print("catched");
      print(SocketException);
      //progressToast("No Internet Connection",true);
      // AlertDialog(
      //   content: SingleChildScrollView(
      //       physics: BouncingScrollPhysics(),
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Icon(
      //             Icons.error,
      //             color: Colors.red,
      //             size: 20,
      //           ),
      //           SizedBox(height: 10),
      //           MyText(
      //             title:
      //                 "There seems to be your network problem or a server side issue. Please try again or report the bug to the manager.",
      //             clr: primaryColor,
      //             size: 13,
      //           ),
      //           SizedBox(height: 20),
      //         ],
      //       )),
      //   actions: <Widget>[
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         MaterialButton(
      //           // color: terColor,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(20.0),
      //           ),
      //           child: Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 4.0),
      //             child: new MyText(
      //               title: "Okay",
      //               size: 13,
      //               clr: Colors.red,
      //             ),
      //           ),
      //           // color: secondaryColor,
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //         ),
      //       ],
      //     ),
      //   ],
      // );
      return null;
    }
  }

  Future basePostAPI(url, body, context,
      {successMsg}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    http.Response response;

    try {
      response = await http.post(Uri.parse(BaseConfig["url"]! + url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(body));

      print(response.statusCode);
      print(response.body);
      var jsonData;
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        print(jsonData);
        if (successMsg != null) {
          progressToast(successMsg, false,context);
        }
        return jsonData;
      } else if (response.statusCode == 401) {
        jsonData = json.decode(response.body);
        if (jsonData["message"].length != 0) {
          progressToast(jsonData["message"], true,context);
        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        return {};
      } else {
        jsonData = json.decode(response.body);
        if (jsonData["message"].length != 0) {
          progressToast(jsonData["message"], true,context);
        }
        throw Exception('Failed');
      }
    } catch (SocketException) {
      print(SocketException);
      return null;
    }
  }
}


class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
      String method,
      Uri url, {
        this.onProgress,
      }) : super(method, url);

  final void Function(int bytes, int totalBytes)? onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = this.contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress!(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}