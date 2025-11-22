import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/widgets/youth_app_bar.dart';

class PolicyWebViewScreen extends StatefulWidget {
  const PolicyWebViewScreen({super.key, required this.url});

  final String url;

  @override
  State<PolicyWebViewScreen> createState() => _PolicyWebViewScreenState();
}

class _PolicyWebViewScreenState extends State<PolicyWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => setState(() {
            _hasError = true;
            _isLoading = false;
          }),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const YouthAppBar(
        title: '정책 상세 보기',
      ),
      body: Stack(
        children: [
          if (_hasError)
            const Center(
              child: Text('페이지를 불러오지 못했습니다.'),
            )
          else
            WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
