class StatementModel {
  const StatementModel({
    required this.id,
    this.month = '',
    this.amount = 0,
    this.status = '',
  });

  final String id;
  final String month;
  final num amount;
  final String status;

  factory StatementModel.fromJson(Map<String, dynamic> json) {
    return StatementModel(
      id: '${json['id'] ?? json['statement_id'] ?? ''}',
      month: '${json['month'] ?? json['period'] ?? json['date'] ?? ''}',
      amount: _num(json['amount'] ?? json['total'] ?? json['total_amount']),
      status: '${json['status'] ?? ''}',
    );
  }

  static num _num(dynamic value) =>
      value is num ? value : num.tryParse('$value') ?? 0;
}
