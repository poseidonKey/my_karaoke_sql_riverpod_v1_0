import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeViewScreen extends StatefulWidget {
  final String songUrl;
  const YoutubeViewScreen({super.key, required this.songUrl});

  @override
  State<YoutubeViewScreen> createState() => _YoutubeViewScreenState();
}

class _YoutubeViewScreenState extends State<YoutubeViewScreen> {
  final TextEditingController _urlController = TextEditingController();
  late WebViewController _webViewController;
  // final String _youtubeUrl = 'https://www.youtube.com/watch?v=S6y2S3tfMRQ';
  @override
  void initState() {
    super.initState();
    _urlController.text = 'https://www.youtube.com/';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('YouTube Player'),
        ),
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: TextField(
            //     controller: _urlController,
            //     decoration: const InputDecoration(
            //       labelText: 'YouTube Video URL',
            //     ),
            //     onChanged: (value) {
            //       setState(() {
            //         _youtubeUrl = value;
            //       });
            //     },
            //   ),
            // ),
            Expanded(
              child: WebView(
                initialUrl: widget.songUrl,
                // initialUrl: _youtubeUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     _webViewController.loadUrl(_youtubeUrl);
                //   },
                //   child: const Text('재생'),
                // ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
