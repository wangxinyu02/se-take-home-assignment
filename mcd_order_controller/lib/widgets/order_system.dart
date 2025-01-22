import 'package:flutter/material.dart';
import 'dart:async'; // Import Dart async library for working with timers
import '../models/order.dart';
import '../models/bot.dart';
import 'bot_list.dart';
import 'order_list.dart';

class OrderSystem extends StatefulWidget {
  const OrderSystem({super.key});

  @override
  OrderSystemState createState() => OrderSystemState();
}

class OrderSystemState extends State<OrderSystem> {
  final List<Order> orders = [];
  final List<Bot> bots = [];
  int nextNormalOrderNumber = 1;
  int nextVipOrderNumber = 1;
  Timer? processingTimer; // Timer for processing orders
  Timer? countdownTimer; // Timer for countdown updates
  static const int processingTime = 10; // Processing time for each order in seconds

  @override
  void initState() {
    super.initState();
    // Start a periodic timer to process orders every second
    processingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => processOrders(),
    );

    // Start a periodic timer to update countdown timers every second
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => updateCountdowns(),
    );
  }

  @override
  void dispose() {
    // Cancel timers when the widget is disposed
    processingTimer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  // Updates the remaining seconds for all orders
  void updateCountdowns() {
    setState(() {
      for (var order in orders) {
        if (order.remainingSeconds != null && order.remainingSeconds! > 0) {
          order.remainingSeconds = order.remainingSeconds! - 1;
        }
      }
    });
  }

  // Generate a unique ID for a new order based on its type
  String generateOrderId(OrderType type) {
    if (type == OrderType.vip) {
      String formattedNumber = nextVipOrderNumber.toString().padLeft(3, '0');
      nextVipOrderNumber++;
      return 'V$formattedNumber';
    } else {
      String formattedNumber = nextNormalOrderNumber.toString().padLeft(3, '0');
      nextNormalOrderNumber++;
      return 'N$formattedNumber';
    }
  }

  // Create a new order and add it to the list
  void createOrder(OrderType type) {
    final newOrder = Order(
      id: generateOrderId(type),
      type: type,
    );

    setState(() {
      if (type == OrderType.vip) {
        // Insert the VIP order after the last pending VIP order
        final lastVipIndex = orders.lastIndexWhere(
          (order) =>
              order.type == OrderType.vip &&
              order.status == OrderStatus.pending,
        );

        if (lastVipIndex == -1) {
          orders.insert(0, newOrder); // No pending VIP orders, insert at the beginning
        } else {
          orders.insert(lastVipIndex + 1, newOrder); // Insert after the last pending VIP order
        }
      } else {
        orders.add(newOrder); // Add normal orders to the end of the list
      }
    });
  }

  // Process orders by assigning them to idle bots
  void processOrders() {
    final idleBots = bots.where((bot) => bot.status == 'IDLE').toList();
    final pendingOrders =
        orders.where((order) => order.status == OrderStatus.pending).toList();

    for (var bot in idleBots) {
      if (pendingOrders.isEmpty) break;

      final orderToProcess = pendingOrders.removeAt(0);
      setState(() {
        // Mark the order as processing
        orderToProcess.status = OrderStatus.processing;
        orderToProcess.remainingSeconds = processingTime;

        // Assign the order to the bot
        bot.status = 'PROCESSING';
        bot.currentOrderId = orderToProcess.id;
      });

      // Simulate processing time
      Future.delayed(const Duration(seconds: processingTime), () {
        setState(() {
          orderToProcess.status =
              OrderStatus.complete; // Mark order as complete
          orderToProcess.remainingSeconds = null; // Clear countdown timer
          bot.status = 'IDLE';
          bot.currentOrderId = null;
        });
      });
    }
  }

  // Add a new bot to the system
  void addBot() {
    setState(() {
      bots.add(Bot(number: bots.length + 1));
      for (int i = 0; i < bots.length; i++) {
        bots[i].number = i + 1;
      }
    });
  }

  // Remove the last bot from the system
  void removeBot() {
    if (bots.isEmpty) return;

    setState(() {
      final lastBot = bots.last;
      if (lastBot.currentOrderId != null) {
        final order = orders.firstWhere((o) => o.id == lastBot.currentOrderId);
        order.status = OrderStatus.pending;
        order.remainingSeconds = null;
      }
      bots.removeLast();
      for (int i = 0; i < bots.length; i++) {
        bots[i].number = i + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('McDonald\'s Order Controller'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: OrderList(
                      title: 'Pending Orders',
                      orders: orders
                          .where((order) =>
                              order.status == OrderStatus.pending ||
                              order.status == OrderStatus.processing)
                          .toList(),
                      showStatus: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OrderList(
                      title: 'Completed Orders',
                      orders: orders
                          .where(
                              (order) => order.status == OrderStatus.complete)
                          .toList(),
                      showStatus: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            BotList(bots: bots),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: () => createOrder(OrderType.normal),
                  child: const Text('New Normal Order'),
                ),
                ElevatedButton(
                  onPressed: () => createOrder(OrderType.vip),
                  child: const Text('New VIP Order'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: addBot,
                  child: const Text('+ Add Bot'),
                ),
                ElevatedButton(
                  onPressed: removeBot,
                  child: const Text('- Remove Bot'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
