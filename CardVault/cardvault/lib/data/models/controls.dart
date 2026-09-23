class ControlsModel {
  const ControlsModel({
    this.online = true,
    this.contactless = true,
    this.international = false,
    this.atm = true,
  });

  final bool online;
  final bool contactless;
  final bool international;
  final bool atm;

  factory ControlsModel.fromJson(Map<String, dynamic> json) {
    return ControlsModel(
      online: _bool(json['online'], true),
      contactless: _bool(json['contactless'], true),
      international: _bool(json['international'], false),
      atm: _bool(json['atm'], true),
    );
  }

  Map<String, dynamic> toJson() => {
        'online': online,
        'contactless': contactless,
        'international': international,
        'atm': atm,
      };

  ControlsModel copyWith({
    bool? online,
    bool? contactless,
    bool? international,
    bool? atm,
  }) {
    return ControlsModel(
      online: online ?? this.online,
      contactless: contactless ?? this.contactless,
      international: international ?? this.international,
      atm: atm ?? this.atm,
    );
  }

  static bool _bool(dynamic value, bool fallback) {
    if (value is bool) return value;
    return fallback;
  }
}
