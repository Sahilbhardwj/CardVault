class BillModel {
  const BillModel({
    required this.id,
    this.name = 'Bill',
    this.amount = 0,
    this.status = 'PENDING',
    this.dueDate = '',
  });

  final String id;
  final String name;
  final num amount;
  final String status;
  final String dueDate;

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: '${json['id'] ?? json['bill_id'] ?? ''}',
      name: '${json['name'] ?? json['merchant'] ?? json['biller'] ?? 'Bill'}',
      amount: _num(json['amount'] ?? json['due_amount']),
      status: '${json['status'] ?? 'PENDING'}',
      dueDate: '${json['due_date'] ?? json['dueDate'] ?? ''}',
    );
  }

  static num _num(dynamic value) =>
      value is num ? value : num.tryParse('$value') ?? 0;
}
