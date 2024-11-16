import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Format the number
    String formatted = '';
    if (digits.isNotEmpty) {
      if (digits[0] == '1' && digits.length <= 11) {
        // Format with country code
        formatted = '+${digits.substring(0, digits.length.clamp(0, 1))}';
        if (digits.length > 1) {
          formatted += ' (${digits.substring(1, digits.length.clamp(1, 4))}';
        }
        if (digits.length > 4) {
          formatted += ') ${digits.substring(4, digits.length.clamp(4, 7))}';
        }
        if (digits.length > 7) {
          formatted += '-${digits.substring(7, digits.length.clamp(7, 11))}';
        }
      } else if (digits[0] != '1' && digits.length <= 10) {
        // Format without country code
        formatted = '(${digits.substring(0, digits.length.clamp(0, 3))}';
        if (digits.length > 3) {
          formatted += ') ${digits.substring(3, digits.length.clamp(3, 6))}';
        }
        if (digits.length > 6) {
          formatted += '-${digits.substring(6, digits.length.clamp(6, 10))}';
        }
      } else {
        // No formatting for numbers longer than 10 digits without country code
        // or longer than 11 digits with country code
        formatted = digits;
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
