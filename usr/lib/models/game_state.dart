import 'player.dart';
import 'playing_card.dart';

enum GamePhase { waiting, preFlop, flop, turn, river, showdown }

class GameState {
  final String id;
  List<Player> players;
  List<PlayingCard> communityCards;
  int pot;
  int currentBet;
  GamePhase phase;
  int dealerIndex;
  int currentPlayerIndex;

  GameState({
    required this.id,
    this.players = const [],
    this.communityCards = const [],
    this.pot = 0,
    this.currentBet = 0,
    this.phase = GamePhase.waiting,
    this.dealerIndex = 0,
    this.currentPlayerIndex = 0,
  });

  GameState copyWith({
    String? id,
    List<Player>? players,
    List<PlayingCard>? communityCards,
    int? pot,
    int? currentBet,
    GamePhase? phase,
    int? dealerIndex,
    int? currentPlayerIndex,
  }) {
    return GameState(
      id: id ?? this.id,
      players: players ?? this.players,
      communityCards: communityCards ?? this.communityCards,
      pot: pot ?? this.pot,
      currentBet: currentBet ?? this.currentBet,
      phase: phase ?? this.phase,
      dealerIndex: dealerIndex ?? this.dealerIndex,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
    );
  }
}
