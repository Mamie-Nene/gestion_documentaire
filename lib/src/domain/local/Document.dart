import 'dart:ui';

class RecentDocument {
  const RecentDocument({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final double progress;
  final Color accentColor;
}