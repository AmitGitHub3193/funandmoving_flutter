import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:funandmoving/Services/APIConstants.dart';
import 'package:funandmoving/SharedWidgets/CustomBottomBar.dart';
import 'package:funandmoving/SharedWidgets/MyText.dart';
import 'package:funandmoving/Utils/colors.dart';

class Telemed extends StatefulWidget {

  @override
  _TelemedState createState() => _TelemedState();
}

class _TelemedState extends State<Telemed> {

  InAppWebViewController? webView;
  Uri? url = Uri.parse("");
  double progress = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primary));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   leading: Container(),
        //   centerTitle: true,
        //   title: MyText(title:'TeleMed',clr: Colors.white,),
        // ),
        bottomNavigationBar: CustomBottomBar(1),
        body: Container(
            child: Column(
                children: <Widget>[
              Container(
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container()),
              Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse("${BaseConfig["url"]}/telemed_flutter_page")),
                  // initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        // debuggingEnabled: true,
                      )
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, Uri? url) {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onLoadStop: (InAppWebViewController controller, Uri? url) async {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                    print(progress);
                  },
                ),
              ),
            ])),
      ),
    );
  }
}
