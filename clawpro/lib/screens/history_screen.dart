import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../providers/app_provider.dart';
import '../widgets/transaction_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _filter = 'all'; // all, recharge, consume

  List<Transaction> _getFilteredTransactions() {
    final transactions = ref.read(appDataProvider).transactions;
    
    if (_filter == 'recharge') {
      return transactions.where((t) => t.transactionType == TransactionType.recharge).toList();
    } else if (_filter == 'consume') {
      return transactions.where((t) => t.transactionType == TransactionType.consume).toList();
    }
    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _getFilteredTransactions();
    final appData = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('历史记录'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                _buildFilterChip('全部', 'all'),
                _buildFilterChip('充值', 'recharge'),
                _buildFilterChip('消费', 'consume'),
              ],
            ),
          ),
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _filter == 'all'
                              ? '暂无记录'
                              : _filter == 'recharge'
                                  ? '暂无充值记录'
                                  : '暂无消费记录',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTransactions.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[filteredTransactions.length - 1 - index];
                      String? payerName;
                      if (transaction.payerId != null) {
                        payerName = appData.members
                            .where((m) => m.id == transaction.payerId)
                            .map((m) => m.name)
                            .firstOrNull;
                      }
                      return TransactionTile(
                        transaction: transaction,
                        payerName: payerName,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filter == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _filter = value;
          });
        },
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
