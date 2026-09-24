import 'package:flutter/material.dart';

import '../betting/betting_screen.dart';
import '../instruction/how_to_play_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sảnh Chính (Main Menu)")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Số dư tài khoản: 100 Coin", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BettingScreen()),
                );
              },
              child: const Text("Bắt Đầu Chơi"),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HowToPlayScreen()),
                );
              },
              child: const Text("Hướng Dẫn Chơi (How to play)"),
            ),
          ],
        ),
      ),
    );
  }
}