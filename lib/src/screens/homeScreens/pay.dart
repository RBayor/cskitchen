import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Pay extends StatefulWidget {
  final bill;
  Pay({this.bill});
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  final String url = "https://ravesandbox.flutterwave.com/pay/cskitchen";
  bool _isLoading = true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final CookieManager cookieManager = CookieManager();
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay GHS ${widget.bill}"),
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
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
