class SendMoneyModel {
  final String id;
  final String transactionId;
  final String transactionType;
  final String amount;
  final String sender;
  final String receiver;
  final String createdAt;

  SendMoneyModel(this.id, this.transactionId, this.transactionType, this.amount,
      this.sender, this.receiver, this.createdAt);

  factory SendMoneyModel.fromJson(Map<String, dynamic> json) {
    print(json['amount'].runtimeType);

    return SendMoneyModel(
        json['_id'],
        json['transactionId'],
        json['transactionType'],
        json['amount'].toString(),
        json['sender'],
        json['receiver'],
        json['createdAt']);
  }
}
