import 'package:pomidor/features/domain/entities/pomodoro_timer.dart';

abstract class TimerRepository {
  Stream<PomodoroTimer> get timerStream;

  void startTimer({required int workDuration, required int breakDuration, bool repeatCycles = false});
  void pauseTimer();
  void resumeTimer();
  void resetTimer();
}