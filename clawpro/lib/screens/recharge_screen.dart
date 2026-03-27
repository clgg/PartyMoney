import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';

class RechargeScreen extends ConsumerStatefulWidget {
  const RechargeScreen({super.key});

  @override
  ConsumerState<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends ConsumerState<RechargeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rechargeController = TextEditingController();
  final _rebateController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedPayerId;

  @override
  void dispose() {
    _rechargeController.dispose();
    _rebateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  double _getRebateDifference() {
    final recharge = double.tryParse(_rechargeController.text) ?? 0.0;
    final rebate = double.tryParse(_rebateController.text) ?? 0.0;
    return rebate - recharge;
  }

  double _getPerMemberContribution() {
    final members = ref.read(appDataProvider).members;
    if (members.isEmpty) return 0.0;
    return _getRebateDifference() / members.length;
  }

  void _handleRecharge() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPayerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择付款人')),
      );
      return;
    }

    final rechargeAmount = double.parse(_rechargeController.text);
    final rebateAmount = double.parse(_rebateController.text);

    ref.read(appDataProvider.notifier).addRecharge(
          rechargeAmount: rechargeAmount,
          rebateAmount: rebateAmount,
          payerId: _selectedPayerId!,
          note: _noteController.text.trim(),
        );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('充值成功！')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('充值记录'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              '充值金额',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _rechargeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: '例如: 100',
                prefixText: '¥ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入充值金额';
                }
                if (double.tryParse(value) == null || double.parse(value) <= 0) {
                  return '请输入有效的金额';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            const Text(
              '返利金额',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _rebateController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: '例如: 110',
                prefixText: '¥ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入返利金额';
                }
                if (double.tryParse(value) == null || double.parse(value) < 0) {
                  return '请输入有效的金额';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '返利差额: ¥${_getRebateDifference().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  if (appData.members.isNotEmpty)
                    Text(
                      '每人贡献: ¥${_getPerMemberContribution().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade700,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '付款人',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedPayerId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: appData.members.map((member) {
                return DropdownMenuItem(
                  value: member.id,
                  child: Text(member.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPayerId = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return '请选择付款人';
                }
                return null;
              },
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
                hintText: '例如: 火锅店充值',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _handleRecharge,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                '确认充值',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
