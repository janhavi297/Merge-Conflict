import 'package:flutter/material.dart';
import 'package:frontend/widget/appbar.dart';
import 'package:frontend/widget/chart.dart';
import 'package:frontend/widget/portfolio.dart';
import 'package:frontend/widget/testchart.dart';

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
          topAppBar('Dashboard', 'Market', 'Trade'),

          // Main Content
          Expanded(
            child: Row(
              children: [
                // Left Side - Chart
                Expanded(
                  flex: 7,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Color(0xFF000000),
                      title: const Text(
                        "Strategy Dashboard",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    body: chartSection(),
                  ),
                ),

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
