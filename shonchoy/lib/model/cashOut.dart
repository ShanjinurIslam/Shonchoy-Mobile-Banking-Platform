class CashOutModel {
  final String id;
  final String transactionId;
  final String transactionType;
  final String amount;
  final String charge;
  final String sender;
  final String receiver;
  final String createdAt;

  CashOutModel(this.id, this.transactionId, this.transactionType, this.amount,
      this.charge, this.sender, this.receiver, this.createdAt);

  factory CashOutModel.fromJson(Map<String, dynamic> json) {
    print(json['amount'].runtimeType);

    return CashOutModel(
        json['_id'],
        json['transactionId'],
        json['transactionType'],
        json['amount'].toString(),
        json['charge'].toString(),
        json['sender'],
        json['receiver'],
        json['createdAt']);
  }
}
