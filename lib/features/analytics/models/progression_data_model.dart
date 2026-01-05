class ProgressionData {
  final double startValue;
  final double currentValue;
  final double percentage;
  final bool isPositive;

  ProgressionData({required this.startValue, required this.currentValue})
    : percentage = startValue != 0
          ? ((currentValue - startValue) / startValue) * 100
          : 0.0,
      isPositive = currentValue >= startValue;
}
