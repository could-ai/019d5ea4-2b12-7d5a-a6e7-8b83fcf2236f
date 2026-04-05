import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/playing_card.dart';

class GameService extends ChangeNotifier {
  GameState _gameState = GameState(id: const Uuid().v4());
  GameState get gameState => _gameState;

  String? _localPlayerId;
  String? get localPlayerId => _localPlayerId;

  List<PlayingCard> _deck = [];

  void createGame(String playerName) {
    _localPlayerId = const Uuid().v4();
    _gameState = GameState(
      id: const Uuid().v4(),
      players: [
        Player(id: _localPlayerId!, name: playerName),
      ],
    );
    notifyListeners();
  }

  void joinGame(String playerName) {
    // For now, this simulates joining a local game
    final newPlayer = Player(id: const Uuid().v4(), name: playerName);
    _gameState.players.add(newPlayer);
    if (_localPlayerId == null) {
      _localPlayerId = newPlayer.id;
    }
    notifyListeners();
  }

  void startGame() {
    if (_gameState.players.length < 2) return;
    
    _gameState.phase = GamePhase.preFlop;
    _gameState.communityCards = [];
    _gameState.pot = 0;
    _gameState.currentBet = 0;
    
    for (var player in _gameState.players) {
      player.resetForNewHand();
    }

    _buildAndShuffleDeck();
    
    // Deal hole cards
    for (int i = 0; i < 2; i++) {
      for (var player in _gameState.players) {
        if (player.status == PlayerStatus.active) {
          player.holeCards.add(_deck.removeLast());
        }
      }
    }

    _gameState.dealerIndex = (_gameState.dealerIndex + 1) % _gameState.players.length;
    _gameState.currentPlayerIndex = (_gameState.dealerIndex + 1) % _gameState.players.length;

    notifyListeners();
  }

  void _buildAndShuffleDeck() {
    _deck = [];
    for (var suit in Suit.values) {
      for (var rank in Rank.values) {
        _deck.add(PlayingCard(suit: suit, rank: rank));
      }
    }
    _deck.shuffle();
  }

  void fold() {
    if (_gameState.phase == GamePhase.waiting || _gameState.phase == GamePhase.showdown) return;
    final player = _gameState.players[_gameState.currentPlayerIndex];
    player.status = PlayerStatus.folded;
    _nextTurn();
  }

  void checkOrCall() {
    if (_gameState.phase == GamePhase.waiting || _gameState.phase == GamePhase.showdown) return;
    final player = _gameState.players[_gameState.currentPlayerIndex];
    int amountToCall = _gameState.currentBet - player.currentBet;
    
    if (player.chips >= amountToCall) {
      player.chips -= amountToCall;
      player.currentBet += amountToCall;
      _gameState.pot += amountToCall;
    } else {
      // All in
      _gameState.pot += player.chips;
      player.currentBet += player.chips;
      player.chips = 0;
      player.status = PlayerStatus.allIn;
    }
    _nextTurn();
  }

  void raise(int amount) {
    if (_gameState.phase == GamePhase.waiting || _gameState.phase == GamePhase.showdown) return;
    final player = _gameState.players[_gameState.currentPlayerIndex];
    int totalBet = _gameState.currentBet + amount;
    int amountToPutIn = totalBet - player.currentBet;

    if (player.chips >= amountToPutIn) {
      player.chips -= amountToPutIn;
      player.currentBet += amountToPutIn;
      _gameState.pot += amountToPutIn;
      _gameState.currentBet = totalBet;
      _nextTurn();
    }
  }

  void _nextTurn() {
    // Simplified turn logic for demonstration
    int startIndex = _gameState.currentPlayerIndex;
    do {
      _gameState.currentPlayerIndex = (_gameState.currentPlayerIndex + 1) % _gameState.players.length;
    } while (_gameState.players[_gameState.currentPlayerIndex].status == PlayerStatus.folded && _gameState.currentPlayerIndex != startIndex);
    
    // Very simplified round advancement
    if (_gameState.currentPlayerIndex == _gameState.dealerIndex || _gameState.players.where((p) => p.status == PlayerStatus.active).length <= 1) {
      _advancePhase();
    } else {
      notifyListeners();
    }
  }

  void _advancePhase() {
    for (var player in _gameState.players) {
      player.currentBet = 0;
    }
    _gameState.currentBet = 0;

    int activePlayers = _gameState.players.where((p) => p.status != PlayerStatus.folded).length;
    if (activePlayers <= 1) {
      _gameState.phase = GamePhase.showdown;
    }

    switch (_gameState.phase) {
      case GamePhase.preFlop:
        _gameState.phase = GamePhase.flop;
        _gameState.communityCards.addAll([_deck.removeLast(), _deck.removeLast(), _deck.removeLast()]);
        break;
      case GamePhase.flop:
        _gameState.phase = GamePhase.turn;
        _gameState.communityCards.add(_deck.removeLast());
        break;
      case GamePhase.turn:
        _gameState.phase = GamePhase.river;
        _gameState.communityCards.add(_deck.removeLast());
        break;
      case GamePhase.river:
        _gameState.phase = GamePhase.showdown;
        _resolveShowdown();
        break;
      case GamePhase.showdown:
        _gameState.phase = GamePhase.waiting;
        break;
      case GamePhase.waiting:
        break;
    }
    notifyListeners();
  }

  void _resolveShowdown() {
    // Mock showdown logic: first active player wins the pot
    try {
      final winner = _gameState.players.firstWhere((p) => p.status != PlayerStatus.folded);
      winner.chips += _gameState.pot;
      _gameState.pot = 0;
    } catch (e) {
      // No active players
    }
  }
}
