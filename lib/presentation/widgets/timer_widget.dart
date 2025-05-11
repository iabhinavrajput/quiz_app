import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/bloc/timer/timer_bloc.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        if (state is TimerRunning) {
          return Text('Time Left: ${state.remainingTime}s');
        } else if (state is TimerCompleted) {
          return const Text('Time Up!');
        }
        return const SizedBox.shrink();
      },
    );
  }
}
