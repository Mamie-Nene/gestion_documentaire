import 'package:flutter/cupertino.dart';

class QuickStat {
  const QuickStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final Color accent;
}