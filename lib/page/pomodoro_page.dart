import 'package:flutter/material.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Timer"),
        ),
        body:
        Center(
            child:
            Text('Pomodoro', style: TextStyle(fontSize: 60))),
    );
  }
}


