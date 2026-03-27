import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final String? payerName;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.payerName,
  });

  @override
  Widget build(BuildContext context) {
    final isRecharge = transaction.transactionType == TransactionType.recharge;
    final dateFormat = DateFormat('MM月dd日 HH:mm');
    final icon = isRecharge ? Icons.account_balance_wallet : Icons.restaurant;
    final color = isRecharge ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(transaction.note.isEmpty ? '未命名' : transaction.note),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isRecharge
                  ? '充值 ¥${transaction.amount.toStringAsFixed(0)} 返¥${(transaction.amount + transaction.fundChange).toStringAsFixed(0)}'
                  : '消费 ¥${transaction.amount.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 12),
            ),
            if (payerName != null)
              Text(
                '付款人: $payerName',
                style: const TextStyle(fontSize: 12),
              ),
            Text(
              dateFormat.format(transaction.createdAt),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              isRecharge ? '+' : '-',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '¥${transaction.fundChange.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
