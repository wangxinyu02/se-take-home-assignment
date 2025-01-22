enum OrderType { normal, vip }
enum OrderStatus { pending, processing, complete }

class Order {
  final String id;
  final OrderType type;
  OrderStatus status;
  final DateTime timestamp;
  int? remainingSeconds;

  Order({
    required this.id,
    required this.type,
    this.status = OrderStatus.pending,
    DateTime? timestamp,
    this.remainingSeconds,
  }) : timestamp = timestamp ?? DateTime.now();
  
}