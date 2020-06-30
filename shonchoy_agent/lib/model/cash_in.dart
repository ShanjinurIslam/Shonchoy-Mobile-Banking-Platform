class CashInModel {
  final String id;
  final String transactionId;
  final String amount;
  final String sender;
  final String receiver;
  final String createdAt;

  CashInModel(this.id, this.transactionId, this.amount, this.sender,
      this.receiver, this.createdAt);

  factory CashInModel.fromJson(Map<String, dynamic> json) {
    return CashInModel(
        json['_id'],
        json['transactionId'],
        json['amount'].toString(),
        json['sender'],
        json['receiver'],
        json['createdAt']);
  }
}
