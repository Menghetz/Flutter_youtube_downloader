import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../downloader.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final link = "https://m.youtube.com/";
  bool _showDownloadButton = false;
  WebViewController? _webViewController;

  void checkUrl() async {
    if (await _webViewController!.currentUrl() == link) {
      print(await _webViewController!.currentUrl());
      setState(() {
        _showDownloadButton = false;
      });
    } else {
      setState(() {
        _showDownloadButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUrl();
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController!.canGoBack()) {
          _webViewController!.goBack();
        }
        return false;
      },
      child: Scaffold(
        body: WebView(
          initialUrl: link,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: ((controller) => {
                setState(() {
                  _webViewController = controller;
                })
              }),
        ),
        floatingActionButton: _showDownloadButton == false
            ? Container()
            : FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () async {
                  final String? url = await _webViewController!.currentUrl();
                  final String? title = await _webViewController!.getTitle();
                  print(title);
                  Download().downloadVideo(url!, title!);
                },
                child: Icon(Icons.download),
              ),
      ),
    );
  }
}
