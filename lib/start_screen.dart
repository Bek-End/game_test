import 'package:flutter/material.dart';
import 'package:test_project/game_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const GameScreen(),
          )),
          child: const Text('Start', style: TextStyle(fontSize: 48)),
        ),
      ),
    );
  }
}
