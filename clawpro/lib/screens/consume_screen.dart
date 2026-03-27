import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';

class ConsumeScreen extends ConsumerStatefulWidget {
  const ConsumeScreen({super.key});

  @override
  ConsumerState<ConsumeScreen> createState() => _ConsumeScreenState();
}

class _ConsumeScreenState extends ConsumerState<ConsumeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _useProportional = true;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  double _getRemainingFund() {
    final currentFund = ref.read(appDataProvider).totalFund;
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    return currentFund - amount;
  }

  void _handleConsume() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);

    ref.read(appDataProvider.notifier).addConsume(
          amount: amount,
          useProportional: _useProportional,
          note: _noteController.text.trim(),
        );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('消费成功！')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(appDataProvider);
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('消费记录'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              '消费金额',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: '例如: 360',
                prefixText: '¥ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入消费金额';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return '请输入有效的金额';
                }
                if (amount > appData.totalFund) {
                  return '金额不能超过当前基金余额';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            const Text(
              '消费方式',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RadioListTile<bool>(
              title: const Text('全额从基金扣'),
              subtitle: const Text('直接从共有基金扣除全部金额'),
              value: false,
              groupValue: _useProportional,
              onChanged: (value) {
                setState(() {
                  _useProportional = value!;
                });
              },
            ),
            RadioListTile<bool>(
              title: const Text('按贡献比例扣'),
              subtitle: const Text('根据每人贡献比例分担消费'),
              value: true,
              groupValue: _useProportional,
              onChanged: (value) {
                setState(() {
                  _useProportional = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '当前基金: ¥${appData.totalFund.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (amount > 0)
                    Text(
                      '消费后余额: ¥${_getRemainingFund().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '备注（可选）',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: '例如: 海底捞聚餐',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _handleConsume,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                '确认消费',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
