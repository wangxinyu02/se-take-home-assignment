import 'package:flutter/material.dart';
import '../models/order.dart';
import '../styles/style.dart';

class OrderList extends StatelessWidget {
  final String title;
  final List<Order> orders;
  final bool showStatus;

  const OrderList({
    super.key,
    required this.title,
    required this.orders,
    required this.showStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyles.cardDecoration(Colors.white),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.headerTextStyle),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: orders.map((order) => Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: AppStyles.cardDecoration(
                  order.type == OrderType.vip
                      ? AppStyles.vipOrderColor
                      : AppStyles.normalOrderColor,
                ),
                child: ListTile(
                  title: Text('Order ${order.id}'),
                  subtitle: showStatus && order.status != OrderStatus.complete
                      ? Text(
                          '${order.status.toString().split('.').last}...',
                          style: AppStyles.orderStatusTextStyle,
                        )
                      : null,
                  trailing: order.status == OrderStatus.processing && order.remainingSeconds != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppStyles.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${order.remainingSeconds}s',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.primaryColor,
                            ),
                          ),
                        )
                      : null,
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}