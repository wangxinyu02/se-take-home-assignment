import 'package:flutter/material.dart';
import '../models/bot.dart';
import '../styles/style.dart';

class BotList extends StatelessWidget {
  final List<Bot> bots;

  const BotList({super.key, required this.bots});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bots (${bots.length})', style: AppStyles.headerTextStyle),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: bots.asMap().entries.map((entry) {
                final bot = entry.value;
                return Card(
                  color: bot.status == 'IDLE'
                      ? AppStyles.botIdleColor
                      : AppStyles.botProcessingColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Bot ${bot.number}'),
                        Text(
                          bot.status == 'PROCESSING'
                              ? 'Order ${bot.currentOrderId}'
                              : 'IDLE',
                          style: AppStyles.botTextStyle,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}