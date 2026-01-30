import 'package:flutter/material.dart';

var capitalController = TextEditingController();

Widget portfolioTradingPanel() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Enter Capital Value
      TextField(
        controller: capitalController,
        decoration: const InputDecoration(labelText: 'Enter capital'),
      ),

      const SizedBox(height: 32),

      // Buy/Hold Tabs
      Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFD4E89E), width: 2),
                ),
              ),
              child: const Text(
                'BUY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Text(
                'HOLD',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(width: 140),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh, color: Colors.white38),
          ),
        ],
      ),

      const SizedBox(height: 32),

      // Company Stock Section
      portfolioIndexSection(
        'IndexName',
        'ABC',
        'Capital',
        'Money',
        const Color(0xFF627EEA),
        'Ξ',
      ),

      const SizedBox(height: 24),

      // USD Section
      portfolioIndexSection(
        'USD',
        'You Spend',
        '9,853.00',
        '12,987.21',
        const Color(0xFFB8D85C),
        '\$',
      ),
    ],
  );
}

Widget portfolioIndexSection(
  String currency,
  String label,
  String amount,
  String balance,
  Color iconColor,
  String symbol,
) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(
        color: Color(0xFFD4E89E), // Set your desired color here
        width: 2.0, // Set the border width
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              currency,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Balance',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
            Text(
              balance,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ],
    ),
  );
}
