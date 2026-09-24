import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const MiniRacingApp());
}

class MiniRacingApp extends StatelessWidget {
  const MiniRacingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Racing Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Khởi đầu từ màn hình Đăng nhập theo yêu cầu của thầy
    );
  }
}