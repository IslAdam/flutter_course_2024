import 'package:flutter/material.dart';
import 'package:pomidor/features/core/data/repositories/timer_repository_impl.dart';
import 'package:provider/provider.dart';
import 'providers/timer_provider.dart';
import 'screens/timer_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerProvider(TimerRepositoryImpl()),
      child: MaterialApp(
        home: TimerScreen(),
      ),
    );
  }
}