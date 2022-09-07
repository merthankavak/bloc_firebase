import '../constants/regex_constants.dart';

extension StringExtension on String {
  String? get isValidEmail =>
      contains(RegExp(RegexConstants.emailRegex)) ? null : 'Email does not valid!';
  bool get isValidEmails => RegExp(RegexConstants.emailRegex).hasMatch(this);
}
