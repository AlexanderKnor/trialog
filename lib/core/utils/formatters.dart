import 'package:intl/intl.dart';

/// Formatting utilities for display purposes
class Formatters {
  Formatters._();

  /// Format currency (default: Euro)
  static String currency(
    num? amount, {
    String symbol = '€',
    int decimalDigits = 2,
    String locale = 'de_DE',
  }) {
    if (amount == null) return '$symbol 0,00';

    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
      locale: locale,
    );

    return formatter.format(amount);
  }

  /// Format number with thousand separators
  static String number(
    num? value, {
    int decimalDigits = 0,
    String locale = 'de_DE',
  }) {
    if (value == null) return '0';

    final formatter = NumberFormat.decimalPattern(locale);
    if (decimalDigits > 0) {
      return formatter.format(value);
    }
    return formatter.format(value.round());
  }

  /// Format percentage
  static String percentage(
    num? value, {
    int decimalDigits = 2,
    String locale = 'de_DE',
  }) {
    if (value == null) return '0%';

    final formatter = NumberFormat.percentPattern(locale);
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;

    return formatter.format(value / 100);
  }

  /// Format date (default: dd.MM.yyyy)
  static String date(
    DateTime? date, {
    String format = 'dd.MM.yyyy',
    String locale = 'de_DE',
  }) {
    if (date == null) return '';

    final formatter = DateFormat(format, locale);
    return formatter.format(date);
  }

  /// Format time (default: HH:mm)
  static String time(
    DateTime? time, {
    String format = 'HH:mm',
    String locale = 'de_DE',
  }) {
    if (time == null) return '';

    final formatter = DateFormat(format, locale);
    return formatter.format(time);
  }

  /// Format datetime
  static String dateTime(
    DateTime? dateTime, {
    String format = 'dd.MM.yyyy HH:mm',
    String locale = 'de_DE',
  }) {
    if (dateTime == null) return '';

    final formatter = DateFormat(format, locale);
    return formatter.format(dateTime);
  }

  /// Format file size
  static String fileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }

  /// Format phone number (German format)
  static String phone(String? phone) {
    if (phone == null || phone.isEmpty) return '';

    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.startsWith('+49')) {
      final rest = cleaned.substring(3);
      if (rest.length >= 3) {
        return '+49 ${rest.substring(0, 3)} ${rest.substring(3)}';
      }
      return '+49 $rest';
    }

    return cleaned;
  }

  /// Capitalize first letter
  static String capitalize(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Capitalize each word
  static String capitalizeWords(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.split(' ').map(capitalize).join(' ');
  }

  /// Truncate text with ellipsis
  static String truncate(String? text, int maxLength) {
    if (text == null || text.isEmpty) return '';
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }
}
