class CashOut {
  final String id;
  final String transactionId;
  final String amount;
  final String sender;
  final String createdAt;

  CashOut(
      this.id, this.transactionId, this.amount, this.sender, this.createdAt);

  factory CashOut.fromJson(Map<String, dynamic> json) {
    return CashOut(json['_id'], json['transactionId'],
        json['amount'].toString(), json['sender'], json['createdAt']);
  }
}
