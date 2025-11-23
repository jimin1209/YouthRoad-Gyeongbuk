import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyWebviewPage extends StatefulWidget {
  const PolicyWebviewPage({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<PolicyWebviewPage> createState() => _PolicyWebviewPageState();
}

class _PolicyWebviewPageState extends State<PolicyWebviewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    final uri = Uri.tryParse(widget.url);
    if (uri == null || uri.toString().isEmpty) {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('유효한 URL이 없습니다.')),
        );
        Navigator.of(context).maybePop();
      });
      return;
    }

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
