// USES LOGIC V5
import 'package:flutter/material.dart';
import 'package:focus_time/page/pomodoro_logic.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart'; // used to Manage the timer state globally. Allows the timer to persist between pages.

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pomodoroLogic = Provider.of<PomodoroLogic>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pomodoro Timer"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pomodoro',
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 20),
            // Text(
            //   'Time Left: ${formatTime(pomodoroLogic.currentTime)}',
            //   style: TextStyle(fontSize: 40),
            // ),
        CircularPercentIndicator(
              radius: 200.0,
              lineWidth: 15.0,
              percent: pomodoroLogic.currentTime / pomodoroLogic.duration,
              center: Text(
                formatTime(pomodoroLogic.currentTime),
                style: TextStyle(fontSize: 55),
              ),
              progressColor: Colors.blue,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!pomodoroLogic.isRunning) {
                      pomodoroLogic.startTimer(25 * 60); // Starts a 25-minute work timer
                    }
                  },
                  child: Text('Start Work'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    if (!pomodoroLogic.isRunning) {
                      pomodoroLogic.startTimer(5 * 60); // Starts a 5-minute break timer
                    }
                  },
                  child: Text('Start Break'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                pomodoroLogic.cancelTimer(); // Cancel and set the timer to zero
              },
              child: Text('Cancel Timer'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (pomodoroLogic.isRunning) {
                  pomodoroLogic.pauseTimer(); // Pauses the timer
                } else {
                  pomodoroLogic.resumeTimer(); // Resumes the timer
                }
              },
              child: Text(pomodoroLogic.isRunning ? 'Pause Timer' : 'Resume Timer'), // changes depending on the current timer state
            ),
          ],
        ),
      ),
    );
  }

  // display time in 00:00 format (minutes and seconds)
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}