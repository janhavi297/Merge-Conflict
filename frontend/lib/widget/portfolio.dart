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
          const SizedBox(width: 80),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh, color: Colors.white38),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.history, color: Colors.white38),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white38),
          ),
        ],
      ),

      const SizedBox(height: 32),

      // ETH Section
      _buildCurrencySection(
        'ETH',
        'You Buy',
        '12.695',
        '293.0187',
        const Color(0xFF627EEA),
        'Ξ',
      ),

      const SizedBox(height: 24),

      // USD Section
      _buildCurrencySection(
        'USD',
        'You Spend',
        '9,853.00',
        '12,987.21',
        const Color(0xFFB8D85C),
        '\$',
      ),

      const SizedBox(height: 24),

      // Buy BTC Button
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFD4E89E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Buy BTC',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),

      const SizedBox(height: 16),

      // Connect Wallet Button
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Connect Wallet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),

      const SizedBox(height: 24),

      // Available Balance Card
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Balance',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  '293.0187 ETH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '+7.45%',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBalanceDetail('Estimate fee', '4.28 USD'),
                _buildBalanceDetail('You will receive', '108.35 USD'),
                _buildBalanceDetail('Spread', '0%'),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildBalanceDetail(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget _buildCurrencySection(
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
