import 'package:flutter/cupertino.dart';

class CategoryCardData {
  const CategoryCardData({
    required this.title,
    required this.icon,
    required this.route,
    required this.gradient,
  });

  final String title;
  final IconData icon;
  final String route;
  final List<Color> gradient;
}