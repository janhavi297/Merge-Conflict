import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/widget/appbar.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Pure black from dashboard
      body: Column(
        children: [
          // 1. Navigation Bar
          topAppBar(false, false, false, true),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),

                  // 2. About Us Section
                  Column(
                    children: [
                      Center(
                        child: const Text(
                          'ABOUT US',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'description',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                  const SizedBox(height: 150),
                  // 3. Feature Grid (Overnight Intelligence)
                  aboutUsCards(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget aboutUsCards() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            aboutUsCard(
              "Global Status",
              "Institutional liquidity flows through dark pools. Monitoring cross-border delta shifts.",
            ),
            const SizedBox(width: 20),
            aboutUsCard(
              "Volatility Index",
              "Precision metrics for after-hours gamma exposure and algorithmic conviction.",
            ),
            const SizedBox(width: 20),
            aboutUsCard(
              "Signal Strength",
              "Real-time data synchronization across major exchange liquidity providers.",
            ),
          ],
        ),
      ],
    ),
  );
}

Widget aboutUsCard(String title, String desc) {
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
