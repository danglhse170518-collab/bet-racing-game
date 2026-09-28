import 'package:flutter/material.dart';
import '../../models/race_result_model.dart';
import '../home/main_screen.dart';

class ResultScreen extends StatelessWidget {
  final RaceResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kết Quả Cuộc Đua")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🏆 Người thắng: Tay đua #${result.winnerRacerId}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Tổng cược: ${result.totalBet} Coin"),
            Text("Nhận về: ${result.totalPayout} Coin"),
            Text("Số dư mới: ${result.newBalance} Coin", style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                      (route) => false,
                );
              },
              child: const Text("Về Sảnh Chính"),
            ),
          ],
        ),
      ),
    );
  }
}