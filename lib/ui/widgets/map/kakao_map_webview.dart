import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/map/kakao_map_controller.dart';
import '../../models/map/kakao_map_options.dart';
import '../../providers/map/kakao_map_providers.dart';
import '../../screens/map/kakao_map_html_builder.dart';

class KakaoMapWebView extends ConsumerStatefulWidget {
  const KakaoMapWebView({
    super.key,
    required this.controller,
    required this.options,
  });

  final KakaoMapController controller;
  final KakaoMapOptions options;

  @override
  ConsumerState<KakaoMapWebView> createState() => _KakaoMapWebViewState();
}

class _KakaoMapWebViewState extends ConsumerState<KakaoMapWebView> {
  late final WebViewController _webViewController;
  final KakaoMapHtmlBuilder _htmlBuilder = const KakaoMapHtmlBuilder();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setupWebView();
  }

  Future<void> _setupWebView() async {
    final html = await _htmlBuilder.build(
      apiKey: widget.controller.apiKey,
      options: widget.options,
      bridgeName: widget.controller.bridgeName,
    );

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(widget.controller.bridgeName, onMessageReceived: (message) {
        widget.controller.handleMessage(message.message);
      })
      ..setOnConsoleMessage((message) {
        debugPrint('[KakaoMapWebView][${message.level}] ${message.message}');
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            widget.controller.markLoading();
            ref.read(kakaoMapStateProvider.notifier).markLoading();
            setState(() {
              _hasError = false;
            });
          },
          onWebResourceError: (error) {
            widget.controller.markError(error.description);
            ref.read(kakaoMapStateProvider.notifier).markError(error.description);
            setState(() {
              _hasError = true;
            });
          },
        ),
      )
      ..loadHtmlString(html, baseUrl: 'https://youthroad.co.kr');

    widget.controller.attachWebViewController(_webViewController);
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(kakaoMapStateProvider);

    return Stack(
      children: [
        WebViewWidget(controller: _webViewController),
        if (_hasError)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '지도를 불러오는 중 오류가 발생했습니다.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(kakaoMapStateProvider.notifier).reload();
                      _webViewController.reload();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          )
        else if (mapState.status != KakaoMapStatus.ready)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x11000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
