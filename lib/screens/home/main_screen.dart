import 'package:flutter/material.dart';

import '../auth/login_screen.dart'; // Đổi đường dẫn theo vị trí file LoginScreen của bạn
import '../betting/betting_screen.dart';
import '../instruction/how_to_play_screen.dart';

class MainScreen extends StatelessWidget {
  final String username;
  final int balance;

  const MainScreen({super.key, required this.username, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sảnh Chính (Main Menu)"),
        actions: [
          // Nút Đăng xuất trên thanh AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Số dư tài khoản: $balance Coin",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        BettingScreen(username: username, balance: balance),
                  ),
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
            const SizedBox(height: 10),
            // Nút Đăng xuất ở dưới menu
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Đăng Xuất"),
            ),
          ],
        ),
      ),
    );
  }
}
