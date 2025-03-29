extension StringExtension on String {
  String get formatSQL {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
