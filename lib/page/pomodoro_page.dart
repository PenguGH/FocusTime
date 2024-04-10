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
      // appBar: AppBar(
      //   title: Text(""),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                '${pomodoroLogic.isWorkSession ? 'Work Session' : 'Break Session'}',
                style: TextStyle(fontSize: 40),
              ),
            Text(
              pomodoroLogic.isRunning ? 'Running' : 'Paused',
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 20),
        CircularPercentIndicator(
          // outer circle of timer to visually show the remaining time left
              radius: 275.0,
              lineWidth: 15.0,
              percent: pomodoroLogic.currentTime / pomodoroLogic.duration,
              center: Text(
                formatTime(pomodoroLogic.currentTime),
                style: TextStyle(fontSize: 75),
              ),
              progressColor: Colors.blue,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // expanded widget allows all the shared widgets to take up space proportional to the amount of space available
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!pomodoroLogic.isRunning) {
                        pomodoroLogic.startTimer(25 * 60); // Starts a 25-minute work timer
                        pomodoroLogic.workSession();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // text color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // rounded corners
                      ),
                      elevation: 3, // elevation
                    ),
                    child: Text('Start Work'),
                  ),
                ),
                // SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!pomodoroLogic.isRunning) {
                        pomodoroLogic.startTimer(5 * 60); // Starts a 5-minute break timer (short break)
                        pomodoroLogic.breakSession();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.orangeAccent, // text color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // rounded corners
                      ),
                      elevation: 3, // elevation
                    ),
                    child: Text('Short Break'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!pomodoroLogic.isRunning) {
                        pomodoroLogic.startTimer(15 * 60); // Starts a 15-minute break timer (long break)
                        pomodoroLogic.breakSession();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.lightBlueAccent, // text color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // rounded corners
                      ),
                      elevation: 3, // elevation
                    ),
                    child: Text('Long Break'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // vertical spacing
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (pomodoroLogic.isRunning) {
                        pomodoroLogic.pauseTimer(); // Pauses the timer
                      } else {
                        pomodoroLogic.resumeTimer(); // Resumes the timer
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.green, // text color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // rounded corners
                      ),
                      elevation: 3, // elevation
                    ),
                    child: Row(
                      // row to display icon and text in the same button
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(pomodoroLogic.isRunning ? Icons.pause : Icons.play_arrow), // Icon changes dynamically depending on the current timer's state
                        SizedBox(width: 8), // To add spacing between the icon and text
                        Text(pomodoroLogic.isRunning ? 'Pause Timer' : 'Resume Timer'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      pomodoroLogic.cancelTimer(); // Cancel and set the timer to zero
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.red, // text color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // rounded corners
                      ),
                      elevation: 3, // elevation
                    ),
                    child: Text('Cancel Timer'),
                  ),
                ),
              ],
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