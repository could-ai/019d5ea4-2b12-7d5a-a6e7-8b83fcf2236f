import 'package:flutter/material.dart';
import '../models/playing_card.dart';

class CardWidget extends StatelessWidget {
  final PlayingCard card;
  final bool hidden;

  const CardWidget({super.key, required this.card, this.hidden = false});

  @override
  Widget build(BuildContext context) {
    if (hidden) {
      return Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.blue[800],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white, width: 2),
        ),
      );
    }

    Color color = (card.suit == Suit.hearts || card.suit == Suit.diamonds) ? Colors.red : Colors.black;

    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          card.shortName,
          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
