class RevealedCardModel {
  const RevealedCardModel({
    this.pan = '',
    this.cvv = '',
    this.expiry = '',
  });

  final String pan;
  final String cvv;
  final String expiry;

  factory RevealedCardModel.fromJson(Map<String, dynamic> json) {
    return RevealedCardModel(
      pan: '${json['pan'] ?? json['card_number'] ?? ''}',
      cvv: '${json['cvv'] ?? ''}',
      expiry: '${json['expiry'] ?? json['expiry_date'] ?? ''}',
    );
  }
}
