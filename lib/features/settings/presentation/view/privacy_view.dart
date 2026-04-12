import 'package:clinic_app/core/widgets/Loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class PolicyScreen extends StatefulWidget {
  final String url;
  final String title;

  const PolicyScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          // ── Loading overlay ─────────────────────────────
          if (_isLoading)
            const Center(child: LoadingSpinner()),
        ],
      ),
    );
  }
}