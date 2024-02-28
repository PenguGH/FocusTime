import 'package:flutter/material.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  int _counter = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Habits"),
        ),
        body:
        Center(
            child:
            Text('Habits', style: TextStyle(fontSize: 60))),

    );
  }
}
