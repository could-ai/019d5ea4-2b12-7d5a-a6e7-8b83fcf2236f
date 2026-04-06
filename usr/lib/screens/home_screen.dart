import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A4A1C), // Dark green
              Color(0xFF0D290E), // Darker green
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / Title area
                const Icon(
                  Icons.casino,
                  size: 80,
                  color: Colors.amber,
                ),
                const SizedBox(height: 20),
                const Text(
                  'TEXAS HOLD\'EM',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black54,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'ONLINE POKER',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.amber,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 80),
                
                // Buttons
                _buildMenuButton(
                  context,
                  title: 'CREATE GAME',
                  icon: Icons.add_circle_outline,
                  onPressed: () {
                    context.read<GameService>().createGame('Player 1');
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  title: 'JOIN GAME',
                  icon: Icons.group_add_outlined,
                  isSecondary: true,
                  onPressed: () {
                    context.read<GameService>().joinGame('Player 2');
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
    bool isSecondary = false,
  }) {
    return Container(
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.white : Colors.amber,
          foregroundColor: isSecondary ? const Color(0xFF1A4A1C) : Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
               title,
               style: const TextStyle(
                 fontSize: 18,
                 fontWeight: FontWeight.bold,
                 letterSpacing: 1.2,
               ),
            ),
          ],
        ),
      ),
    );
  }
}
