import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hướng Dẫn Chơi")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("LUẬT CHƠI:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("1. Bạn có số vốn khởi điểm là 100 coin."),
            Text("2. Có 3 đối tượng tham gia đường đua song song."),
            Text("3. Bạn có thể kéo thanh trượt để chọn thời gian đua tùy ý (3s - 15s)."),
            Text("4. Đặt cược vào tay đua bạn nghĩ sẽ về nhất."),
            Text("5. Nếu đoán đúng: Nhận lại tiền cược + tiền thưởng."),
            Text("6. Nếu đoán sai: Mất số tiền đã cược."),
          ],
        ),
      ),
    );
  }
}