class CardModel {
  const CardModel({
    required this.id,
    this.last4 = '----',
    this.status = 'ACTIVE',
    this.cardholderName = 'Cardholder',
    this.network = 'VISA',
    this.expiry = '--/--',
    this.type = 'Credit Card',
  });

  final String id;
  final String last4;
  final String status;
  final String cardholderName;
  final String network;
  final String expiry;
  final String type;

  bool get isBlocked => status.toUpperCase() == 'BLOCKED';

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: '${json['id'] ?? json['card_id'] ?? ''}',
      last4: '${json['last4'] ?? json['last_four'] ?? '----'}',
      status: '${json['status'] ?? 'ACTIVE'}',
      cardholderName:
          '${json['cardholder_name'] ?? json['cardholderName'] ?? 'Cardholder'}',
      network: '${json['network'] ?? 'VISA'}',
      expiry: '${json['expiry'] ?? json['expiry_date'] ?? '--/--'}',
      type: '${json['type'] ?? 'Credit Card'}',
    );
  }
}
