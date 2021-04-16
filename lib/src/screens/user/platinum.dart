import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Platinum extends StatefulWidget {
  @override
  _PlatinumState createState() => _PlatinumState();
}

class _PlatinumState extends State<Platinum> {
  final String url = "https://www.platinumgh.com";

  bool _isLoading = true;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebView(
            key: _key,
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              _controller.complete(controller);
            },
            onPageFinished: (finish) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
