import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://stfrancisnyc.org/st-francis-live/',
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
