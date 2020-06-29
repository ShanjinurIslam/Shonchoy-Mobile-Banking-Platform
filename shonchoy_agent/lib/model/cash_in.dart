class CashIn {
  final String id;
  final String transactionId;
  final String amount;
  final String sender;
  final String receiver;
  final String createdAt;

  CashIn(this.id, this.transactionId, this.amount, this.sender, this.receiver,
      this.createdAt);

  factory CashIn.fromJson(Map<String, dynamic> json) {
    return CashIn(json['_id'], json['transactionId'], json['amount'].toString(),
        json['sender'], json['receiver'], json['createdAt']);
  }
}
