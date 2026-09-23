class LimitsModel {
  const LimitsModel({
    this.dailyPurchase = 0,
    this.dailyAtm = 0,
    this.contactless = 0,
  });

  final num dailyPurchase;
  final num dailyAtm;
  final num contactless;

  factory LimitsModel.fromJson(Map<String, dynamic> json) {
    return LimitsModel(
      dailyPurchase: _num(json['daily_purchase']),
      dailyAtm: _num(json['daily_atm']),
      contactless: _num(json['contactless']),
    );
  }

  Map<String, dynamic> toJson() => {
        'daily_purchase': dailyPurchase,
        'daily_atm': dailyAtm,
        'contactless': contactless,
      };

  static num _num(dynamic value) {
    if (value is num) return value;
    return num.tryParse('$value') ?? 0;
  }
}
