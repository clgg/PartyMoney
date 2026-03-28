import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../models/transaction.dart';
import '../models/app_data.dart';
import '../services/storage_service.dart';

final appDataProvider = StateNotifierProvider<AppDataNotifier, AppData>((ref) {
  return AppDataNotifier();
});

class AppDataNotifier extends StateNotifier<AppData> {
  final StorageService _storage = StorageService();
  bool _dirty = false;

  AppDataNotifier() : super(AppData()) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await _storage.init();
      final data = await _storage.loadData();
      if (!_dirty) state = data;
    } catch (_) {}
  }

  Future<void> addMember(String name) async {
    _dirty = true;
    final member = Member(
      id: _storage.generateId(),
      name: name,
      contribution: 0.0,
    );

    final newMembers = [...state.members, member];
    state = state.copyWith(members: newMembers);
    // 使用 saveData 确保所有数据都保存
    await _storage.saveData(state);
  }

  Future<void> updateMember(Member member) async {
    _dirty = true;
    final newMembers = state.members.map((m) {
      return m.id == member.id ? member : m;
    }).toList();

    state = state.copyWith(members: newMembers);
    // 使用 saveData 确保所有数据都保存
    await _storage.saveData(state);
  }

  Future<void> deleteMember(String memberId) async {
    if (state.members.length <= 1) {
      throw Exception('至少保留一名成员');
    }
    _dirty = true;

    final newMembers = state.members.where((m) => m.id != memberId).toList();
    state = state.copyWith(members: newMembers);
    // 使用 saveData 确保所有数据都保存
    await _storage.saveData(state);
  }

  Future<void> addRecharge({
    required double rechargeAmount,
    required double rebateAmount,
    required String payerId,
    required String note,
  }) async {
    if (state.members.isEmpty) {
      throw Exception('请先添加成员');
    }
    _dirty = true;

    final rebateDifference = rebateAmount - rechargeAmount;

    // 只给选定的付款人增加贡献金额（返利差额）
    final contributions = <String, double>{};
    for (final member in state.members) {
      contributions[member.id] = (member.id == payerId) ? rebateDifference : 0.0;
    }

    final transaction = Transaction(
      id: _storage.generateId(),
      type: TransactionType.recharge,
      amount: rechargeAmount,
      fundChange: rebateDifference,
      payerId: payerId,
      note: note,
      createdAt: DateTime.now(),
      contributions: contributions,
    );

    final newTransactions = [...state.transactions, transaction];
    final newFund = state.totalFund + rebateDifference;

    final newMembers = state.members.map((m) {
      return Member(
        id: m.id,
        name: m.name,
        contribution: (m.contribution + (contributions[m.id] ?? 0)),
      );
    }).toList();

    state = AppData(
      members: newMembers,
      transactions: newTransactions,
      totalFund: newFund,
    );

    await _storage.saveData(state);
  }

  Future<void> addConsume({
    required double amount,
    required bool useProportional,
    required String note,
  }) async {
    if (state.totalFund < amount) {
      throw Exception('基金余额不足');
    }
    _dirty = true;

    final contributions = <String, double>{};

    if (useProportional) {
      final totalContribution = state.members.fold<double>(
        0.0,
        (sum, m) => sum + m.contribution,
      );

      if (totalContribution > 0) {
        for (final member in state.members) {
          final ratio = member.contribution / totalContribution;
          contributions[member.id] = -(amount * ratio);
        }
      }
    }

    final transaction = Transaction(
      id: _storage.generateId(),
      type: TransactionType.consume,
      amount: amount,
      fundChange: -amount,
      note: note,
      createdAt: DateTime.now(),
      contributions: contributions,
    );

    final newTransactions = [...state.transactions, transaction];
    final newFund = state.totalFund - amount;

    List<Member> newMembers = state.members;

    if (useProportional) {
      newMembers = state.members.map((m) {
        return Member(
          id: m.id,
          name: m.name,
          contribution: (m.contribution + (contributions[m.id] ?? 0)),
        );
      }).toList();
    }

    state = AppData(
      members: newMembers,
      transactions: newTransactions,
      totalFund: newFund,
    );

    await _storage.saveData(state);
  }

  Member? getMemberById(String id) {
    try {
      return state.members.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  double getTotalRecharge() {
    return state.transactions
        .where((t) => t.transactionType == TransactionType.recharge)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  double getTotalConsume() {
    return state.transactions
        .where((t) => t.transactionType == TransactionType.consume)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  double getTodayRecharge() {
    final today = DateTime.now();
    return state.transactions
        .where((t) =>
            t.transactionType == TransactionType.recharge &&
            t.createdAt.year == today.year &&
            t.createdAt.month == today.month &&
            t.createdAt.day == today.day)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  double getTodayConsume() {
    final today = DateTime.now();
    return state.transactions
        .where((t) =>
            t.transactionType == TransactionType.consume &&
            t.createdAt.year == today.year &&
            t.createdAt.month == today.month &&
            t.createdAt.day == today.day)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }
}
