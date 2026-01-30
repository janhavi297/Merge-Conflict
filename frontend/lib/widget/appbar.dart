import 'package:flutter/material.dart';

// this widget is for app bar on the dashboard website
Widget topAppBar() {
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
              'NocturneCapital',
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

// this widget is for color change on the tabs of dashboard
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
