import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:liturgia_diaria/interface/appbar/appbar.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String titulo;

  const WebViewPage({super.key, required this.url, required this.titulo});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  int _progresso = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) => setState(() => _progresso = p),
        onPageFinished: (_) => setState(() => _progresso = 100),
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Notícia', haveDrawer: false),
      body: Column(
        children: [
          if (_progresso < 100)
            LinearProgressIndicator(
              value: _progresso / 100,
              minHeight: 3,
            ),
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
