/// Input validation utilities
class Validators {
  Validators._();

  /// Email validation regex
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Phone number validation regex (international format)
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  /// Validate email address
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validate phone number
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return _phoneRegex.hasMatch(phone.trim());
  }

  /// Validate required field
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validate minimum length
  static bool hasMinLength(String? value, int minLength) {
    if (value == null) return false;
    return value.length >= minLength;
  }

  /// Validate maximum length
  static bool hasMaxLength(String? value, int maxLength) {
    if (value == null) return true;
    return value.length <= maxLength;
  }

  /// Validate numeric value
  static bool isNumeric(String? value) {
    if (value == null || value.isEmpty) return false;
    return double.tryParse(value) != null;
  }

  /// Validate positive number
  static bool isPositive(String? value) {
    if (!isNumeric(value)) return false;
    final number = double.parse(value!);
    return number > 0;
  }

  /// Validate integer
  static bool isInteger(String? value) {
    if (value == null || value.isEmpty) return false;
    return int.tryParse(value) != null;
  }

  /// Validate password strength
  static bool isStrongPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    if (password.length < 8) return false;

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }

  /// Validate date format (YYYY-MM-DD)
  static bool isValidDateFormat(String? date) {
    if (date == null || date.isEmpty) return false;
    try {
      DateTime.parse(date);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Validate URL
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (_) {
      return false;
    }
  }
}
