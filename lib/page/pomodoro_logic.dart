// logic v5
// Pomodoro timer is used to help you get work done and take much needed breaks.
// It helps you focus and lock in to the tasks that you need to do!
// The point of the pomodoro technique is to get you to be more disciplined and consistent in slowly making progress on your work! :)
// Slow incremental progress adds up over time!

// Pomodoro logic:
// 1 full pomodoro session consists of 4 parts:
// Part 1: 25 min of work and then a 5 min break
// Part 2: 25 min of work and then a 5 min break
// Part 3: 25 min of work and then a 5 min break
// Part 4: 25 min of work and then a 15-30 min break. (this is a longer break on the 4th part of the pomodoro cycle to give you a little more of a break before starting the next pomodoro session.
// During the work timer: you should focus on making progress on your work and avoid distractions.
// During the break timer: you should go and stretch, walk around, use the restroom, and step away from your work area.
// After the break you can come back to work recharged!

// total: 1 pomodoro session:
// 100 minutes of work
// 30-45 minutes of break. low end to high end. depends how much of a break you need.
import 'dart:async';
import 'package:flutter/foundation.dart';

class PomodoroLogic extends ChangeNotifier {
  // initialization
  int _duration = 0;
  int _currentTime = 0;
  Timer? _timer;
  bool _isRunning = false; // to determine the timer's state. if the timer is running or if its paused
  bool _isWorkSession = false; // to determine if it is a work session or a break session

  // getters
  int get duration => _duration;
  int get currentTime => _currentTime;
  bool get isRunning => _isRunning;
  bool get isWorkSession => _isWorkSession;

  void startTimer(int durationInSeconds) {
    _duration = durationInSeconds;
    _currentTime = durationInSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentTime <= 0) {
        _timer!.cancel();
        _isRunning = false;
        notifyListeners();
      } else {
        _currentTime--; // decrement timer by 1 second, for every second of time that passes
        notifyListeners();
      }
    });
    _isRunning = true;
    notifyListeners();
  }

  void cancelTimer() {
    _timer?.cancel();
    _isRunning = false;
    _currentTime = 0;
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resumeTimer() {
    startTimer(_currentTime);
  }

  void workSession() {
    _isWorkSession = true;
  }

  void breakSession() {
    _isWorkSession = false;
  }
}
