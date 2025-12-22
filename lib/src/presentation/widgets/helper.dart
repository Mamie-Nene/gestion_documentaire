

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper{

  String getFileExtension(String? mimeType, String? fileName) {
    if (mimeType?.contains('pdf') ?? false) return 'PDF';
    if (mimeType?.contains('word') ?? false || mimeType!.contains('document') ?? false) return 'DOCX';
    if (mimeType?.contains('excel') ?? false || mimeType!.contains('spreadsheet') ?? false) return 'XLSX';
    if (mimeType?.contains('powerpoint') ?? false || mimeType!.contains('presentation') ?? false) return 'PPTX';
    return 'DOCX';
  }

  Color getFileTypeColor(String fileType) {
    switch (fileType.toUpperCase()) {
      case 'DOCX':
        return Color(0xff1D4ED8);
      case 'XLSX':
        return Color(0xff185C37);
      default:
        return Color(0xffBC3618);
    }
  }

  String getFileTypeIcon(String fileType) {
    switch (fileType.toUpperCase()) {
      case 'PDF':
        return 'pdf';
      case 'DOCX':
        return 'word';
      case 'XLSX':
        return 'excel';
      case 'PPTX':
        return 'powerpoint';
      default:
        return 'pdf';
    }
  }
  String getFileTypeText(String fileType) {
    switch (fileType.toUpperCase()) {
      case 'PDF':
        return 'PDF';
      case 'DOCX':
        return 'word';
      case 'XLSX':
        return 'excel';
      case 'PPTX':
        return 'PPTX';
      default:
        return 'PDF';
    }
  }

  String formatFileSize(String? fileName) {
    // Mock file size for now
    return '2.4MB';
  }

  DateTime parseEventDate(String date) {
    return DateTime.parse(date);
  }

  String formatMonth(DateTime date) {
    return DateFormat('MMM').format(date).toLowerCase() + '.';
  }

  String formatDay(DateTime date) {
    return DateFormat('dd').format(date);
  }

  String formatHour(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}