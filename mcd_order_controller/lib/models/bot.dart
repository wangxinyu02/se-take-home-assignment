class Bot {
  int number;
  String status;
  String? currentOrderId;

  Bot({
    required this.number,
    this.status = 'IDLE',
    this.currentOrderId,
  });
}