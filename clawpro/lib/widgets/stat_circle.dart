import 'package:flutter/material.dart';

class StatCircle extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isIncome;

  const StatCircle({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final valueStr = value > 0 ? (isIncome ? '+' : '-') + '¥${value.toStringAsFixed(0)}' : '¥0';

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                valueStr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
