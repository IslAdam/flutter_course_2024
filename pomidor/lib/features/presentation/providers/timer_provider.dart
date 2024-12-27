import 'package:flutter/material.dart';
import 'package:pomidor/features/domain/entities/pomodoro_timer.dart';
import 'package:pomidor/features/domain/repositories/timer_repository.dart';

class TimerProvider with ChangeNotifier {
  final TimerRepository _repository;

  late Stream<PomodoroTimer> _timerStream;
  PomodoroTimer? _currentTimer;

  TimerProvider(this._repository) {
    _timerStream = _repository.timerStream;
    _timerStream.listen((timer) {
      _currentTimer = timer;
      notifyListeners();
    });
  }

  PomodoroTimer? get currentTimer => _currentTimer;

  void startTimer(int workDuration, int breakDuration, {bool repeatCycles = false}) {
    _repository.startTimer(workDuration: workDuration, breakDuration: breakDuration, repeatCycles: repeatCycles);
  }

  void pauseTimer() {
    _repository.pauseTimer();
  }

  void resumeTimer() {
    _repository.resumeTimer();
  }

  void resetTimer() {
    _repository.resetTimer();
  }

  void updateDurations({required int newWorkDuration, required int newBreakDuration}) {
    _currentTimer = _currentTimer?.copyWith(
      workDuration: newWorkDuration,
      breakDuration: newBreakDuration,
    );
    notifyListeners();
  }
}
