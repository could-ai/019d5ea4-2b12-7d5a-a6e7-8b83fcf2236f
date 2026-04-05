import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../services/game_service.dart';
import '../widgets/card_widget.dart';
import '../widgets/player_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Poker Table')),
      body: Consumer<GameService>(
        builder: (context, gameService, child) {
          final state = gameService.gameState;
          final localPlayerId = gameService.localPlayerId;

          return Column(
            children: [
              // Top area: Other players
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: state.players
                      .where((p) => p.id != localPlayerId)
                      .map((p) => PlayerWidget(
                            player: p,
                            isCurrentTurn: state.players.isNotEmpty && state.players[state.currentPlayerIndex].id == p.id,
                            isLocalPlayer: false,
                          ))
                      .toList(),
                ),
              ),
              
              // Middle area: Table (Community cards & Pot)
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[800],
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.brown, width: 10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Pot: \$${state.pot}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: state.communityCards.map((c) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: CardWidget(card: c),
                          )).toList(),
                        ),
                        if (state.phase == GamePhase.waiting)
                          ElevatedButton(
                            onPressed: () => gameService.startGame(),
                            child: const Text('Start Game'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom area: Local player & Controls
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    if (state.players.any((p) => p.id == localPlayerId))
                      PlayerWidget(
                        player: state.players.firstWhere((p) => p.id == localPlayerId),
                        isCurrentTurn: state.players.isNotEmpty && state.players[state.currentPlayerIndex].id == localPlayerId,
                        isLocalPlayer: true,
                      ),
                    const SizedBox(height: 16),
                    if (state.players.isNotEmpty && state.players[state.currentPlayerIndex].id == localPlayerId && state.phase != GamePhase.waiting && state.phase != GamePhase.showdown)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => gameService.fold(),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Fold'),
                          ),
                          ElevatedButton(
                            onPressed: () => gameService.checkOrCall(),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: const Text('Check/Call'),
                          ),
                          ElevatedButton(
                            onPressed: () => gameService.raise(50),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: const Text('Raise 50'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
