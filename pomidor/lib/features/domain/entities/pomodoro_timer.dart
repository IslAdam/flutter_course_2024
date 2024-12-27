enum TimerStatus { initial, running, paused, completed }

class PomodoroTimer {
  final int workDuration; // Work interval in seconds
  final int breakDuration; // Break interval in seconds
  final TimerStatus status;
  final int remainingTime; // Time remaining in the current interval
  final bool isWorkInterval; // Flag indicating whether it's work or break interval
  final int cycleCount; // Number of completed cycles

  PomodoroTimer({
    required this.workDuration,
    required this.breakDuration,
    required this.status,
    required this.remainingTime,
    required this.isWorkInterval,
    required this.cycleCount,
  });

  PomodoroTimer copyWith({
    int? workDuration,
    int? breakDuration,
    TimerStatus? status,
    int? remainingTime,
    bool? isWorkInterval,
    int? cycleCount,
  }) {
    return PomodoroTimer(
      workDuration: workDuration ?? this.workDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      status: status ?? this.status,
      remainingTime: remainingTime ?? this.remainingTime,
      isWorkInterval: isWorkInterval ?? this.isWorkInterval,
      cycleCount: cycleCount ?? this.cycleCount,
    );
  }
}