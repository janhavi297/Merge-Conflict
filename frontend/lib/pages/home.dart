import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/widget/appbar.dart';

class NocturnHome extends StatefulWidget {
  const NocturnHome({super.key});

  @override
  State<NocturnHome> createState() => _NocturnHomeState();
}

class _NocturnHomeState extends State<NocturnHome> {
  // Track active tab for the color change
  String activeTab = "Terminal";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Pure black from dashboard
      body: Column(
        children: [
          // 1. Navigation Bar
          topAppBar("Dashboard", "Insights", "Our Edge"),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  // 2. Hero Section
                  middleSection(),
                  const SizedBox(height: 80),
                  // 3. Feature Grid (Overnight Intelligence)
                  newsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget middleSection() {
    return Column(
      children: [
        const Text(
          'NOCTURN CAPITALS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 64,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'High-precision overnight market intelligence and systematic trading suggestions\ndesigned for the institutional investor.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => TradingDashboard(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFFD4E89E,
                ), // Lime Green from dashboard
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'START TRADING',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 20),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('VIEW STRATEGY'),
            ),
          ],
        ),
      ],
    );
  }

  Widget newsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              newsCard(
                "Global Status",
                "Institutional liquidity flows through dark pools. Monitoring cross-border delta shifts.",
              ),
              const SizedBox(width: 20),
              newsCard(
                "Volatility Index",
                "Precision metrics for after-hours gamma exposure and algorithmic conviction.",
              ),
              const SizedBox(width: 20),
              newsCard(
                "Signal Strength",
                "Real-time data synchronization across major exchange liquidity providers.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget newsCard(String title, String desc) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D), // Dark grey from dashboard
          border: Border.all(color: const Color(0xFF222222)), // Subtle border
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              desc,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
