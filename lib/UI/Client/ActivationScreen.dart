import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:funandmoving/Models/RegisterDevice.dart';
import 'package:funandmoving/Services/Services.dart';
import 'package:funandmoving/SharedWidgets/MyText.dart';
import 'package:funandmoving/Utils/TextConstants.dart';
import 'package:funandmoving/Utils/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivationScreen extends StatefulWidget {
  @override
  _ActivationScreenState createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Services services = Services();
  var deviceData = <String, dynamic>{};
  RegisterDevice device = RegisterDevice();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceData();
  }

  getDeviceData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString(DEVICE_DETAIL);
    if (data == null) {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
      print(deviceData);
      device = await services.registerDevice(context, deviceData);
    } else {
      device = RegisterDevice.fromJson(jsonDecode(data));
    }
    setState(() {});
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'Make': build.manufacturer,
      'Model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'Make'
          'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Container(),
        centerTitle: true,
        title: MyText(title:'Activation',clr: Colors.white,),
      ),
      body: Center(
          child: device.shortcode == null
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QrImage(
                      data: "https://www.funandmoving.com/activate/${device.shortcode}",
                      version: QrVersions.auto,
                      size: 150.0,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MyText(
                      center: true,
                      title:
                          "Visit our website and\nenter the activation code below\nfor a Free 14 days trial",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          title: "Activation Code: ",
                        ),
                        MyText(
                          title: "${device.shortcode}",
                          weight: "Bold",
                          size: 18,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () async {
                        String _url="https://www.funandmoving.com/activate/${device.shortcode}";
                        await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                      },
                      child: MyText(
                        title: "funandmoving.com/activate/${device.shortcode}",
                        clr: kColorRatingStar,
                        size: 18,
                      ),
                    ),
                  ],
                )),
    );
  }
}
