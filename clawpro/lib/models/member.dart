class Member {
  final String id;
  String name;
  double contribution;

  Member({
    required this.id,
    required this.name,
    this.contribution = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'contribution': contribution,
      };

  factory Member.fromJson(Map<String, dynamic> j) => Member(
        id: j['id'] as String,
        name: j['name'] as String,
        contribution: (j['contribution'] as num).toDouble(),
      );

  Member copyWith({
    String? id,
    String? name,
    double? contribution,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      contribution: contribution ?? this.contribution,
    );
  }
}
