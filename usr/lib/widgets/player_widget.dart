import 'package:flutter/material.dart';
import '../models/player.dart';
import 'card_widget.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  final bool isCurrentTurn;
  final bool isLocalPlayer;

  const PlayerWidget({
    super.key,
    required this.player,
    this.isCurrentTurn = false,
    this.isLocalPlayer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentTurn ? Colors.yellow[100] : Colors.white,
        border: Border.all(color: isCurrentTurn ? Colors.orange : Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('\$${player.chips}'),
          if (player.currentBet > 0) Text('Bet: \$${player.currentBet}', style: const TextStyle(color: Colors.blue)),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: player.holeCards.map((card) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: CardWidget(
                  card: card, 
                  hidden: !isLocalPlayer && player.status != PlayerStatus.folded
                ),
              );
            }).toList(),
          ),
          if (player.status == PlayerStatus.folded)
            const Text('FOLDED', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
