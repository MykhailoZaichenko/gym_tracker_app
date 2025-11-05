int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

String formatNumberCompact(double v) {
  if (v >= 1000000000000) return '${(v / 1000000000000).toStringAsFixed(1)}T';
  if (v >= 1000000000) return '${(v / 1000000000).toStringAsFixed(1)}B';
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
  if (v == v.roundToDouble()) return v.toInt().toString();
  return v.toStringAsFixed(1);
}
