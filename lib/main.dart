import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'app_module.dart';
import 'app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize();
  runApp(AppWidget());
}
