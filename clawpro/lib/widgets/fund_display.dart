import 'package:flutter/material.dart';

class FundDisplay extends StatelessWidget {
  final double fund;

  const FundDisplay({
    super.key,
    required this.fund,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          const Text(
            '💰 当前基金',
            style: TextStyle(
              fontSize: 16,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¥ ${fund.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
