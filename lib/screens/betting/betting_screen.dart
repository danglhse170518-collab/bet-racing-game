import 'package:flutter/material.dart';
import '../../models/racer_model.dart';
import '../../models/bet_model.dart';
import '../../services/racer_repository_impl.dart';
import '../race/race_screen.dart';

class BettingScreen extends StatefulWidget {
  const BettingScreen({super.key});

  @override
  State<BettingScreen> createState() => _BettingScreenState();
}

class _BettingScreenState extends State<BettingScreen> {
  final _racerRepo = RacerRepositoryImpl();
  late List<Racer> _racers;
  int _baseDurationSeconds = 5; // Tùy chỉnh thời gian chạy (giây)

  @override
  void initState() {
    super.initState();
    _racers = _racerRepo.getRacers(); // Lấy đúng 3 đối tượng đua
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đặt Cược (3 Làn Đua)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thanh Slider chỉnh thời gian đua tùy ý
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Thời gian đua: $_baseDurationSeconds giây"),
                Slider(
                  value: _baseDurationSeconds.toDouble(),
                  min: 3,
                  max: 15,
                  divisions: 12,
                  onChanged: (val) => setState(() => _baseDurationSeconds = val.toInt()),
                ),
              ],
            ),
            const Divider(),
            // 3 ô nhập cược cố định
            Expanded(
              child: ListView.builder(
                itemCount: _racers.length,
                itemBuilder: (context, i) {
                  final racer = _racers[i];
                  return ListTile(
                    leading: Icon(racer.icon, color: racer.color),
                    title: Text(racer.name),
                    trailing: const SizedBox(
                      width: 90,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "Số coin"),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RaceScreen(
                      racers: _racers,
                      baseDurationSeconds: _baseDurationSeconds,
                      bets: [BetItem(racerId: 1, betAmount: 20)], // Mẫu dữ liệu cược
                      currentBalance: 100,
                    ),
                  ),
                );
              },
              child: const Text("Bắt đầu cuộc đua"),
            )
          ],
        ),
      ),
    );
  }
}