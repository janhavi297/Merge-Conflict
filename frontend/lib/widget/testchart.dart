import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

class TestChart extends StatelessWidget {
  const TestChart({super.key});

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory(
      'chart-view',
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = 'http://127.0.0.1:8000/chart'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';

        return iframe;
      },
    );

    return const HtmlElementView(viewType: 'chart-view');
  }
}
