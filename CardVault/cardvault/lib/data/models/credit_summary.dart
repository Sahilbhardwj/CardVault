class CreditSummaryModel {
  const CreditSummaryModel({
    this.totalLimit = 0,
    this.availableCredit = 0,
    this.usedCredit = 0,
    this.dueAmount = 0,
    this.utilization = 0,
  });

  final num totalLimit;
  final num availableCredit;
  final num usedCredit;
  final num dueAmount;
  final num utilization;

  factory CreditSummaryModel.fromJson(Map<String, dynamic> json) {
    final utilization = _num(
      json['utilization'] ?? json['utilisation'] ?? json['utilization_percent'],
    );

    return CreditSummaryModel(
      totalLimit: _num(json['total_limit'] ?? json['credit_limit']),
      availableCredit: _num(
        json['available_credit'] ?? json['available'],
      ),
      usedCredit: _num(json['used_credit'] ?? json['used']),
      dueAmount: _num(json['due_amount'] ?? json['due']),
      utilization: utilization,
    );
  }

  static num _num(dynamic value) =>
      value is num ? value : num.tryParse('$value') ?? 0;
}
