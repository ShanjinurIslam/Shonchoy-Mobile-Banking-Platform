class Transaction {
  final String id;
  final String type;
  final String amount;
  final String sender;
  final String receiver;
  final String pos;
  final String createdAt;

  Transaction(
      {this.id,
      this.type,
      this.amount,
      this.sender,
      this.receiver,
      this.pos,
      this.createdAt});

  factory Transaction.fromJson(Map<String, dynamic> json) {

    return Transaction(
        id: json['_id'],
        type: json['type'],
        amount: json['amount'].toString(),
        sender: json['sender'],
        receiver: json['receiver'],
        pos: json['as'],
        createdAt: json['createdAt']);
  }
}
