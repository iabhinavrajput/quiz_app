import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TimerEvent {}

class StartTimer extends TimerEvent {}

class StopTimer extends TimerEvent {}

abstract class TimerState {}

class TimerInitial extends TimerState {}

class TimerRunning extends TimerState {
  final int remainingTime;
  TimerRunning(this.remainingTime);
}

class TimerCompleted extends TimerState {}

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(TimerInitial());

  late Timer _timer;
  int _remainingTime = 30; // Timer duration in seconds

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if (event is StartTimer) {
      yield* _startTimer(); // Start the timer and yield states
    } else if (event is StopTimer) {
      yield TimerCompleted(); // Stop the timer and complete
    }
  }

  // Method to start the timer
  Stream<TimerState> _startTimer() async* {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        add(StartTimer()); // Keep adding the StartTimer event to decrease time
      } else {
        add(StopTimer()); // Stop timer once time is up
      }
    });
    yield TimerRunning(_remainingTime); // Dispatch the timer running state
  }
}
