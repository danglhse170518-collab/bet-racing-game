import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/racer_model.dart';
import '../../models/bet_model.dart';
import '../../services/race_engine_impl.dart';
import '../result/result_screen.dart';

class RaceScreen extends StatefulWidget {
  final List<Racer> racers;
  final int baseDurationSeconds;
  final List<BetItem> bets;
  final int currentBalance;
  final String username;

  const RaceScreen({
    super.key,
    required this.racers,
    required this.baseDurationSeconds,
    required this.bets,
    required this.currentBalance,
    required this.username,
  });

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  // Mỗi tick cập nhật vị trí 1 lần, AnimatedPositioned làm mượt giữa các tick
  static const _tick = Duration(milliseconds: 100);

  final _engine = RaceEngineImpl();
  final _random = Random();
  late List<Duration> _durations;
  late List<double> _progress; // 0.0 = vạch xuất phát, 1.0 = vạch đích
  Timer? _timer;
  int? _countdown;
  bool _isRacing = false;
  int? _winnerId;

  bool get _hasStarted => _countdown != null || _isRacing || _winnerId != null;

  @override
  void initState() {
    super.initState();
    // Tính toán thời gian ngẫu nhiên dựa trên baseDuration do người chơi chọn
    _durations = _engine.calculateDurations(
      racerCount: widget.racers.length,
      baseDurationSeconds: widget.baseDurationSeconds,
    );
    _progress = List.filled(widget.racers.length, 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRace() {
    setState(() => _countdown = 3);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown! > 1) {
        setState(() => _countdown = _countdown! - 1);
        return;
      }
      timer.cancel();
      setState(() {
        _countdown = null;
        _isRacing = true;
      });
      _timer = Timer.periodic(_tick, (_) => _step());
    });
  }

  void _step() {
    int? leader;
    setState(() {
      for (var i = 0; i < _progress.length; i++) {
        // Tốc độ trung bình theo duration ngẫu nhiên, mỗi tick dao động
        // 50%-150% để các tay đua có thể vượt nhau
        final avgStep = _tick.inMilliseconds / _durations[i].inMilliseconds;
        _progress[i] += avgStep * (0.5 + _random.nextDouble());
        if (_progress[i] >= 1 &&
            (leader == null || _progress[i] > _progress[leader!])) {
          leader = i;
        }
      }
    });
    if (leader != null) _onFinish(widget.racers[leader!].id);
  }

  void _onFinish(int racerId) {
    if (_winnerId != null) return;
    _timer?.cancel();
    setState(() {
      _winnerId = racerId;
      _isRacing = false;
    });
    final result = _engine.calculateResult(
      bets: widget.bets,
      winnerId: racerId,
      currentBalance: widget.currentBalance,
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            result: result,
            racers: widget.racers,
            username: widget.username,
          ),
        ),
      );
    });
  }

  int _betFor(Racer racer) => widget.bets
      .where((bet) => bet.racerId == racer.id)
      .fold(0, (sum, bet) => sum + bet.betAmount);

  String get _statusText {
    if (_countdown != null) return '$_countdown';
    if (_isRacing) return 'Đang đua...';
    if (_winnerId != null) {
      final winner = widget.racers.firstWhere((r) => r.id == _winnerId);
      return '🏆 ${winner.name} về nhất!';
    }
    return 'Nhấn START để bắt đầu';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Không cho thoát giữa chừng khi cuộc đua đã bắt đầu
      canPop: !_hasStarted,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Đường Đua 3 Làn"),
          automaticallyImplyLeading: !_hasStarted,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _statusText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.racers.length,
                    itemBuilder: (context, i) {
                      final racer = widget.racers[i];
                      return _RaceLane(
                        racer: racer,
                        progress: min(_progress[i], 1.0),
                        betAmount: _betFor(racer),
                        isWinner: racer.id == _winnerId,
                        stepDuration: _tick,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _hasStarted ? null : _startRace,
                    child: const Text("START RUN"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Một làn đua: "slider giả" gồm track là Container, racer là Icon
/// di chuyển bằng AnimatedPositioned.
class _RaceLane extends StatelessWidget {
  static const _racerSize = 40.0;
  static const _finishWidth = 14.0;

  final Racer racer;
  final double progress;
  final int betAmount;
  final bool isWinner;
  final Duration stepDuration;

  const _RaceLane({
    required this.racer,
    required this.progress,
    required this.betAmount,
    required this.isWinner,
    required this.stepDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                racer.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: racer.color,
                ),
              ),
              const Spacer(),
              Text(betAmount > 0 ? 'Cược: $betAmount Coin' : 'Không cược'),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isWinner ? Colors.amber : Colors.transparent,
                width: 3,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxLeft =
                    constraints.maxWidth - _racerSize - _finishWidth - 4;
                return Stack(
                  children: [
                    // Vạch kẻ giữa làn
                    Center(
                      child: Container(height: 2, color: Colors.white24),
                    ),
                    // Vạch xuất phát
                    Positioned(
                      left: _racerSize + 4,
                      top: 0,
                      bottom: 0,
                      child: Container(width: 2, color: Colors.white),
                    ),
                    // Vạch đích
                    const Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: _finishWidth,
                      child: _FinishLine(),
                    ),
                    AnimatedPositioned(
                      duration: stepDuration,
                      curve: Curves.linear,
                      left: 2 + progress * maxLeft,
                      top: (54 - _racerSize) / 2,
                      child: Icon(
                        racer.icon,
                        color: racer.color,
                        size: _racerSize,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Vạch đích dạng ô cờ đen trắng.
class _FinishLine extends StatelessWidget {
  const _FinishLine();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        6,
        (row) => Expanded(
          child: Row(
            children: List.generate(
              2,
              (col) => Expanded(
                child: Container(
                  color: (row + col).isEven ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
