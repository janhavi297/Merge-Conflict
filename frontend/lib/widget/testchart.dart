// import 'dart:html' as html;
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';

// class ChartView extends StatelessWidget {
//   const ChartView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     if (kIsWeb) {
//       // ignore: undefined_prefixed_name
//       ui.platformViewRegistry.registerViewFactory(
//         'chart-view',
//         (int viewId) => html.IFrameElement()
//           ..src = 'http://127.0.0.1:8000/chart'
//           ..style.border = 'none',
//       );

//       return const HtmlElementView(viewType: 'chart-view');
//     }

//     return const Center(
//       child: Text('Chart view is only available on Web'),
//     );
//   }
// }