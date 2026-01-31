import 'package:flutter/material.dart';
import 'package:frontend/pages/home.dart';

// this widget is for app bar on the dashboard website
Widget topAppBar(
  bool A,
  bool B,
  bool C,
  bool D,
) {
  return Container(
    color: Color(0xFF000000),
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
              'Nocturne Capital',
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
        buildNavItem('Home', A),
        const SizedBox(width: 40),
        buildNavItem('Dashboard', B),
        const SizedBox(width: 40),
        buildNavItem('News', C),
        const SizedBox(width: 40),
        buildNavItem('About Us', D),
      ],
    ),
  );
}

// this widget is for color change on the tabs of dashboard
Widget buildNavItem(String title, bool isActive) {
  return Text(
    title,
    style: TextStyle(
      color: isActive ? Colors.white : Colors.white54,
      fontSize: 15,
      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
    ),
  );
}
