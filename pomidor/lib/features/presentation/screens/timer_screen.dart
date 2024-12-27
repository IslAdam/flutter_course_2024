import 'package:flutter/material.dart';
import 'package:pomidor/features/domain/entities/pomodoro_timer.dart';
import 'package:pomidor/features/presentation/providers/timer_provider.dart';
import 'package:provider/provider.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final TextEditingController workController = TextEditingController();
  final TextEditingController breakController = TextEditingController();
  bool _repeatCycles = false;

  Color _getBackgroundColor(PomodoroTimer? timer) {
    if (timer == null || timer.status == TimerStatus.initial || timer.status == TimerStatus.completed) return Colors.white;
    if (timer.status == TimerStatus.paused) return Colors.grey;
    return timer.isWorkInterval ? Colors.red : Colors.green;
  }

  String _getStatusText(PomodoroTimer? timer) {
    if (timer == null || timer.status == TimerStatus.initial) return 'No timer running';
    if (timer.status == TimerStatus.completed) return 'Timer Completed';
    if (timer.status == TimerStatus.paused) return 'Pause';
    return timer.isWorkInterval ? 'Work' : 'Break';
  }

  double _getProgress(PomodoroTimer? timer) {
    if (timer == null || timer.status == TimerStatus.initial || timer.status == TimerStatus.completed) return 0.0;
    final totalDuration = timer.isWorkInterval ? timer.workDuration : timer.breakDuration;
    return 1 - (timer.remainingTime / totalDuration);
  }

  Widget _buildCycleIndicators(int cycleCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(cycleCount, (index) =>
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimerProvider>(context);
    final timer = provider.currentTimer;

    return Scaffold(
      backgroundColor: _getBackgroundColor(timer),
      appBar: AppBar(title: Text('Pomodoro Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (timer != null && timer.status != TimerStatus.completed) ...[
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: _getProgress(timer),
                      backgroundColor: Colors.grey[300],
                      color: timer.isWorkInterval ? Colors.red : Colors.green,
                      strokeWidth: 10,
                    ),
                  ),
                ],
                Text(
                  _getStatusText(timer),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (timer != null) ...[
              Text('Time Remaining: ${timer.remainingTime}s', style: TextStyle(fontSize: 20)),
              _buildCycleIndicators(timer.cycleCount),
            ],
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _repeatCycles,
                  onChanged: (value) {
                    setState(() {
                      _repeatCycles = value ?? false;
                    });
                  },
                ),
                Text('Repeat Cycles'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                provider.startTimer(
                  int.tryParse(workController.text) ?? 1500,
                  int.tryParse(breakController.text) ?? 300,
                  repeatCycles: _repeatCycles,
                );
              },
              child: Text('Start Timer'),
            ),
            ElevatedButton(
              onPressed: provider.pauseTimer,
              child: Text('Pause Timer'),
            ),
            ElevatedButton(
              onPressed: provider.resumeTimer,
              child: Text('Resume Timer'),
            ),
            ElevatedButton(
              onPressed: provider.resetTimer,
              child: Text('Reset Timer'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: workController,
              decoration: InputDecoration(labelText: 'Work Duration (seconds)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: breakController,
              decoration: InputDecoration(labelText: 'Break Duration (seconds)'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final workDuration = int.tryParse(workController.text) ?? 1500;
                final breakDuration = int.tryParse(breakController.text) ?? 300;
                provider.updateDurations(newWorkDuration: workDuration, newBreakDuration: breakDuration);
              },
              child: Text('Update Intervals'),
            ),
          ],
        ),
      ),
    );
  }
}