import 'package:flutter/material.dart';
import 'package:frontend/widget/appbar.dart';
import 'package:frontend/widget/chart.dart';
import 'package:frontend/widget/portfolio.dart';

class TradingDashboard extends StatefulWidget {
  const TradingDashboard({super.key});

  @override
  State<TradingDashboard> createState() => _TradingDashboardState();
}

class _TradingDashboardState extends State<TradingDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // App Bar
          topAppBar(),

          // Main Content
          Expanded(
            child: Row(
              children: [
                // Left Side - Chart
                Expanded(flex: 7, child: chartSection()),

                // Right Side - Portfolio
                Container(
                  width: 380,
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    // Add this
                    // padding: const EdgeInsets.all(24),
                    child: portfolioTradingPanel(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
