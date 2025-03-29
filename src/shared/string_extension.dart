extension StringExtension on String {
  String get formatText {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
