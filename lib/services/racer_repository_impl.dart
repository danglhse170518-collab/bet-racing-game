import 'package:flutter/material.dart';
import '../models/racer_model.dart';
import 'interfaces/i_racer_repository.dart';

class RacerRepositoryImpl implements IRacerRepository {
  final List<Color> _colors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.amber,
  ];

  final List<IconData> _icons = [
    Icons.sports_motorsports,
    Icons.directions_car,
    Icons.pets,
  ];

  @override
  List<Racer> getRacers() {
    // Tự sinh đúng 3 đối tượng đua theo vòng lặp, không gán cứng tên cố định
    return List.generate(3, (index) {
      int id = index + 1;
      return Racer(
        id: id,
        name: "Tay đua #$id",
        color: _colors[index],
        icon: _icons[index],
      );
    });
  }
}