import '../../models/racer_model.dart';

abstract class IRacerRepository {
  List<Racer> getRacers();
}