import 'member.dart';
import 'transaction.dart';

class AppData {
  List<Member> members;
  List<Transaction> transactions;
  double totalFund;

  AppData({
    List<Member>? members,
    List<Transaction>? transactions,
    this.totalFund = 0.0,
  })  : members = members ?? [],
        transactions = transactions ?? [];

  AppData copyWith({
    List<Member>? members,
    List<Transaction>? transactions,
    double? totalFund,
  }) {
    return AppData(
      members: members ?? this.members,
      transactions: transactions ?? this.transactions,
      totalFund: totalFund ?? this.totalFund,
    );
  }

  Map<String, dynamic> toJson() => {
        'members': members.map((e) => e.toJson()).toList(),
        'transactions': transactions.map((e) => e.toJson()).toList(),
        'totalFund': totalFund,
      };

  factory AppData.fromJson(Map<String, dynamic> j) => AppData(
        members: (j['members'] as List<dynamic>)
            .map((e) => Member.fromJson(e as Map<String, dynamic>))
            .toList(),
        transactions: (j['transactions'] as List<dynamic>)
            .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalFund: (j['totalFund'] as num).toDouble(),
      );
}
