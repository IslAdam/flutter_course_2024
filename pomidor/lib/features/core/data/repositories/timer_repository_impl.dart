import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:pomidor/features/domain/entities/pomodoro_timer.dart';
import 'package:pomidor/features/domain/repositories/timer_repository.dart';

class TimerRepositoryImpl implements TimerRepository {
  final StreamController<PomodoroTimer> _controller = StreamController<PomodoroTimer>.broadcast();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Timer? _timer;
  late PomodoroTimer _currentTimer;

  int _cycleCount = 0; // To track the number of cycles completed
  bool _repeatCycles = false; // To enable/disable repeating cycles

  @override
  Stream<PomodoroTimer> get timerStream => _controller.stream;

  @override
  void startTimer({required int workDuration, required int breakDuration, bool repeatCycles = false}) {
    _repeatCycles = repeatCycles;
    _cycleCount = 1;
    _currentTimer = PomodoroTimer(
      workDuration: workDuration,
      breakDuration: breakDuration,
      status: TimerStatus.running,
      remainingTime: workDuration,
      isWorkInterval: true,
      cycleCount: _cycleCount,
    );
    _controller.add(_currentTimer);
    _runTimer();
  }

  @override
  void pauseTimer() {
    _timer?.cancel();
    _currentTimer = _currentTimer.copyWith(status: TimerStatus.paused);
    _controller.add(_currentTimer);
  }

  @override
  void resumeTimer() {
    if (_currentTimer.status == TimerStatus.paused) {
      _currentTimer = _currentTimer.copyWith(status: TimerStatus.running);
      _controller.add(_currentTimer);
      _runTimer();
    }
  }

  @override
  void resetTimer() {
    _timer?.cancel();
    _cycleCount = 0;
    _currentTimer = _currentTimer.copyWith(
      status: TimerStatus.initial,
      remainingTime: _currentTimer.workDuration,
      isWorkInterval: true,
      cycleCount: 0,
    );
    _controller.add(_currentTimer);
  }
  Future<void> _playSound(String assetPath) async {
    await _audioPlayer.play(assetPath, isLocal: true);
  }

  void _runTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentTimer.remainingTime > 0) {
        _currentTimer = _currentTimer.copyWith(remainingTime: _currentTimer.remainingTime - 1);
        _controller.add(_currentTimer);
      } else {
        timer.cancel();
        if (_currentTimer.isWorkInterval) {
          // Play sound for work interval end
          _playSound('assets/sounds/work_end.mp3');

          // Switch to break
          _currentTimer = _currentTimer.copyWith(
            status: TimerStatus.running,
            remainingTime: _currentTimer.breakDuration,
            isWorkInterval: false,
          );
          _controller.add(_currentTimer);
          _runTimer();
        } else {
          // Play sound for break interval end
          _playSound('assets/sounds/break_end.mp3');

          // Break completed
          if (_repeatCycles) {
            _cycleCount++;
            _currentTimer = _currentTimer.copyWith(
              status: TimerStatus.running,
              remainingTime: _currentTimer.workDuration,
              isWorkInterval: true,
              cycleCount: _cycleCount,
            );
            _controller.add(_currentTimer);
            _runTimer();
          } else {
            _currentTimer = _currentTimer.copyWith(
              status: TimerStatus.completed,
              isWorkInterval: true,
            );
            _controller.add(_currentTimer);
          }
        }
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
    _audioPlayer.dispose();
  }
}