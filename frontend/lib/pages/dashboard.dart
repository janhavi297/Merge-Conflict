import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TradingDashboard extends StatefulWidget {
  const TradingDashboard({super.key});

  @override
  State<TradingDashboard> createState() => _TradingDashboardState();
}

class _TradingDashboardState extends State<TradingDashboard> {
  String selectedTimeframe = '24h';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // App Bar
          _buildAppBar(),

          // Main Content
          Expanded(
            child: Row(
              children: [
                // Left Side - Chart
                Expanded(flex: 7, child: _buildChartSection()),

                // Right Side - Trading Panel
                Container(
                  width: 380,
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    // Add this
                    // padding: const EdgeInsets.all(24),
                    child: _buildTradingPanel(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F5B8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Color(0xFF1A1A1A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'LumaTrade',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Navigation
          _buildNavItem('Dashboard', true),
          const SizedBox(width: 40),
          _buildNavItem('Trade', false),
          const SizedBox(width: 40),
          _buildNavItem('Market', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, bool isActive) {
    return Text(
      title,
      style: TextStyle(
        color: isActive ? Colors.white : Colors.white54,
        fontSize: 15,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildChartSection() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currency Selector and Price
          Row(
            children: [
              // Currency Icons
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF627EEA),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'Ξ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8D85C),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '\$',
                          style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Text(
                'ETH/USD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
            ],
          ),

          const SizedBox(height: 24),

          // Price and Change
          Row(
            children: [
              const Text(
                '\$3,615.86',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '+3.27% today',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(),

              // Chart Type Icons
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.show_chart, color: Colors.white54),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bar_chart, color: Colors.white54),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Timeframe Selector
          Row(
            children: [
              const Spacer(),
              _buildTimeframeButton('1h'),
              _buildTimeframeButton('24h'),
              _buildTimeframeButton('1w'),
              _buildTimeframeButton('1m'),
            ],
          ),

          const SizedBox(height: 24),

          // Chart
          Expanded(child: _buildChart()),

          const SizedBox(height: 24),

          // Exchange List
          _buildExchangeList(),
        ],
      ),
    );
  }

  Widget _buildTimeframeButton(String label) {
    final isSelected = selectedTimeframe == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeframe = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A2A2A) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white38,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 15,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.05),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 15,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}.00',
                  style: const TextStyle(color: Colors.white24, fontSize: 11),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 4,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const times = [
                  '2:00 AM',
                  '6:00 AM',
                  '10:00 AM',
                  '12:00 PM',
                  '2:00 PM',
                  '4:00 PM',
                ];
                if (value.toInt() >= 0 && value.toInt() < times.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      times[value.toInt()],
                      style: const TextStyle(
                        color: Colors.white24,
                        fontSize: 11,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 5,
        minY: 3555,
        maxY: 3630,
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 3570),
              const FlSpot(0.5, 3625),
              const FlSpot(1, 3600),
              const FlSpot(1.5, 3565),
              const FlSpot(2, 3580),
              const FlSpot(2.5, 3590),
              const FlSpot(3, 3575),
              const FlSpot(3.5, 3595),
              const FlSpot(4, 3610),
              const FlSpot(4.5, 3590),
              const FlSpot(5, 3620),
            ],
            isCurved: true,
            gradient: LinearGradient(
              colors: [const Color(0xFFFF9966), const Color(0xFFCCCC66)],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF9966).withOpacity(0.3),
                  const Color(0xFFCCCC66).withOpacity(0.1),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            //tooltipBgColor: const Color(0xFF2A2A2A),
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExchangeList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text(
                  'Exchange',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
              Expanded(
                child: Text(
                  'BNB/USD',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
              Expanded(
                child: Text(
                  'Amount',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
              Expanded(
                child: Text(
                  'Diff',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Volume',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Exchange Rows
          _buildExchangeRow(
            'UniSwap',
            Colors.pink,
            '3,615.32',
            '1.6254 ETH',
            'Limited',
            const Color(0xFF4A5D3E),
            '\$5,875.00',
          ),
          const SizedBox(height: 12),
          _buildExchangeRow(
            'SushiSwap',
            Colors.purple,
            '3,617.12',
            '1.6203 ETH',
            'Trending',
            const Color(0xFF4A3D5D),
            '\$5,860.12',
          ),
          const SizedBox(height: 12),
          _buildExchangeRow(
            'PancakeSwap',
            Colors.cyan,
            '3,620.00',
            '1.5000 ETH',
            'Rising',
            const Color(0xFF3D4D5D),
            '\$5,430.00',
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRow(
    String name,
    Color iconColor,
    String price,
    String amount,
    String status,
    Color statusColor,
    String volume,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.swap_horiz, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            price,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            amount,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            volume,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTradingPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  Widget _buildBalanceDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
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
}
