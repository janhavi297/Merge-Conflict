import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/widget/appbar.dart';
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
                Expanded(flex: 7, child: _buildChartSection()),

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
              Icon(Icons.money, color: Colors.white),
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

          // Chart
          Expanded(child: _buildChart()),

          const SizedBox(height: 24),

          // Exchange List
          _buildExchangeList(),
        ],
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
      height: 125,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
