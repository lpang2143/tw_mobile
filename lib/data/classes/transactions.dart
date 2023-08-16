class Transaction {
  BigInt mainTransactionId;
  DateTime transactionTime;
  String transferAmount;
  int buyerUserId;
  int promotionId;

  Transaction({
    required this.mainTransactionId,
    required this.transactionTime,
    required this.transferAmount,
    required this.buyerUserId,
    required this.promotionId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      mainTransactionId: BigInt.from(json['main_transaction_id']),
      transactionTime: json['transaction_time'],
      transferAmount: json['transfer_amount'],
      buyerUserId: json['buyer_user_id'],
      promotionId: json['promotion_id'],
    );
  }

  static List<Transaction> fromJsonList(List<dynamic> jsonList) {
    List<Transaction> transactions = [];
    for (var json in jsonList) {
      transactions.add(Transaction.fromJson(json));
    }
    return transactions;
  }

  Map<String, dynamic> toJson() {
    return {
      'main_transaction_id': mainTransactionId.toString(),
      'transaction_time': transactionTime,
      'transfer_amount': transferAmount,
      'buyer_user_id': buyerUserId,
      'promotion_id': promotionId,
    };
  }

  BigInt getMainTransactionId() {
    return mainTransactionId;
  }

  DateTime getTransactionTime() {
    return transactionTime;
  }

  String getTransferAmount() {
    return transferAmount;
  }

  int getBuyerUserId() {
    return buyerUserId;
  }

  int getPromotionId() {
    return promotionId;
  }
}

class SubTransaction {
  BigInt subTransactionId;
  String transferAmount;
  int sellerUserId;
  int promotionId;
  int ticketId;
  BigInt mainTransactionId;

  SubTransaction({
    required this.subTransactionId,
    required this.transferAmount,
    required this.sellerUserId,
    required this.promotionId,
    required this.ticketId,
    required this.mainTransactionId,
  });

  factory SubTransaction.fromJson(Map<String, dynamic> json) {
    return SubTransaction(
      subTransactionId: BigInt.from(json['sub_transaction_id']),
      transferAmount: json['transfer_amount'],
      sellerUserId: json['seller_user_id'],
      promotionId: json['promotion_id'],
      ticketId: json['ticket_id'],
      mainTransactionId: BigInt.from(json['main_transaction_id']),
    );
  }

  static List<SubTransaction> fromJsonList(List<dynamic> jsonList) {
    List<SubTransaction> subTransactions = [];
    for (var json in jsonList) {
      subTransactions.add(SubTransaction.fromJson(json));
    }
    return subTransactions;
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_transaction_id': subTransactionId.toString(),
      'transfer_amount': transferAmount,
      'seller_user_id': sellerUserId,
      'promotion_id': promotionId,
      'ticket_id': ticketId,
      'main_transaction_id': mainTransactionId.toString(),
    };
  }

  BigInt getSubTransactionId() {
    return subTransactionId;
  }

  String getTransferAmount() {
    return transferAmount;
  }

  int getSellerUserId() {
    return sellerUserId;
  }

  int getPromotionId() {
    return promotionId;
  }

  int getTicketId() {
    return ticketId;
  }

  BigInt getMainTransactionId() {
    return mainTransactionId;
  }
}
