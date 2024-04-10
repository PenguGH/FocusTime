// logic v5
import 'dart:async';
import 'package:flutter/foundation.dart';

class PomodoroLogic extends ChangeNotifier {
  int _duration = 0;
  int _currentTime = 0;
  Timer? _timer;
  bool _isRunning = false;

  int get duration => _duration;
  int get currentTime => _currentTime;
  bool get isRunning => _isRunning;

  void startTimer(int durationInSeconds) {
    _duration = durationInSeconds;
    _currentTime = durationInSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentTime <= 0) {
        _timer!.cancel();
        _isRunning = false;
        notifyListeners();
      } else {
        _currentTime--;
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
}
