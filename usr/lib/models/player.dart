import 'playing_card.dart';

enum PlayerStatus { active, folded, allIn, waiting }

class Player {
  final String id;
  final String name;
  int chips;
  int currentBet;
  List<PlayingCard> holeCards;
  PlayerStatus status;

  Player({
    required this.id,
    required this.name,
    this.chips = 1000,
    this.currentBet = 0,
    this.holeCards = const [],
    this.status = PlayerStatus.waiting,
  });

  void resetForNewHand() {
    holeCards = [];
    currentBet = 0;
    if (chips > 0) {
      status = PlayerStatus.active;
    } else {
      status = PlayerStatus.waiting; // Out of chips
    }
  }

  Player copyWith({
    String? id,
    String? name,
    int? chips,
    int? currentBet,
    List<PlayingCard>? holeCards,
    PlayerStatus? status,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      chips: chips ?? this.chips,
      currentBet: currentBet ?? this.currentBet,
      holeCards: holeCards ?? this.holeCards,
      status: status ?? this.status,
    );
  }
}
