enum TransactionType { recharge, consume }

class Transaction {
  final String id;
  final int type;
  final double amount;
  final double fundChange;
  final String? payerId;
  final String note;
  final DateTime createdAt;
  final Map<String, double> contributions;

  Transaction({
    required this.id,
    required TransactionType type,
    required this.amount,
    required this.fundChange,
    this.payerId,
    required this.note,
    required this.createdAt,
    required this.contributions,
  }) : type = type.index;

  TransactionType get transactionType {
    return TransactionType.values[type];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': transactionType.name,
        'amount': amount,
        'fundChange': fundChange,
        'payerId': payerId,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
        'contributions': contributions,
      };

  factory Transaction.fromJson(Map<String, dynamic> j) {
    final t = TransactionType.values.firstWhere(
      (e) => e.name == j['type'] as String,
    );
    final raw = j['contributions'];
    final Map<String, double> contrib = {};
    if (raw is Map) {
      raw.forEach((k, v) {
        contrib[k.toString()] = (v as num).toDouble();
      });
    }
    return Transaction(
      id: j['id'] as String,
      type: t,
      amount: (j['amount'] as num).toDouble(),
      fundChange: (j['fundChange'] as num).toDouble(),
      payerId: j['payerId'] as String?,
      note: j['note'] as String,
      createdAt: DateTime.parse(j['createdAt'] as String),
      contributions: contrib,
    );
  }
}
