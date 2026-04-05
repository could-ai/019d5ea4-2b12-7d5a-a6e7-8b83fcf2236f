import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Texas Hold\'em')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<GameService>().createGame('Player 1');
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
              },
              child: const Text('Create Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<GameService>().joinGame('Player 2');
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
              },
              child: const Text('Join Game'),
            ),
          ],
        ),
      ),
    );
  }
}
