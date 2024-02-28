// import 'package:flutter/material.dart';
//
// class PomodoroPage extends StatefulWidget {
//   const PomodoroPage({super.key});
//
//   @override
//   State<PomodoroPage> createState() => _PomodoroPageState();
// }
//
// class _PomodoroPageState extends State<PomodoroPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Timer"),
//         ),
//         body:
//         Center(
//             child:
//             Text('Pomodoro', style: TextStyle(fontSize: 60))),
//     );
//   }
// }

// import 'package:flutter/material.dart';
//
// class PomodoroPage extends StatefulWidget {
//   const PomodoroPage({Key? key}) : super(key: key);
//
//   @override
//   State<PomodoroPage> createState() => _PomodoroPageState();
// }
//
// class _PomodoroPageState extends State<PomodoroPage> {
//   int workDuration = 25;
//   int breakDuration = 5;
//   int longBreakDuration = 15;
//   int cycles = 4;
//   int currentCycle = 1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Pomodoro Timer"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Pomodoro',
//               style: TextStyle(fontSize: 40),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Cycle $currentCycle/$cycles',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             Text(
//               '00:00',
//               style: TextStyle(fontSize: 60),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Implement start work functionality
//                   },
//                   child: Text('Start Work'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Implement start break functionality
//                   },
//                   child: Text('Start Break'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({Key? key}) : super(key: key);

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int workDuration = 25;
  int breakDuration = 5;
  int longBreakDuration = 15;
  int cycles = 4;
  int currentCycle = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pomodoro Timer"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'Pomodoro',
            //   style: TextStyle(fontSize: 40),
            // ),
            SizedBox(height: 20),
            Text(
              'Cycle $currentCycle/$cycles',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            CircularCountDownTimer(
              duration: workDuration * 60,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              ringColor: Colors.blue, // Use ringColor instead of controllerColor
              fillColor: Colors.white,
              strokeWidth: 10.0,
              textStyle: TextStyle(fontSize: 60, color: Colors.black),
              onComplete: () {
                // Implement logic for timer completion
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement start work functionality
                  },
                  child: Text('Start Work'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement start break functionality
                  },
                  child: Text('Start Break'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

