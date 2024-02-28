// import 'package:flutter/material.dart';
//
// class HabitsPage extends StatefulWidget {
//   const HabitsPage({super.key});
//
//   @override
//   State<HabitsPage> createState() => _HabitsPageState();
// }
//
// class _HabitsPageState extends State<HabitsPage> {
//   int _counter = 0;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Habits"),
//         ),
//         body:
//         Center(
//             child:
//             Text('Habits', style: TextStyle(fontSize: 60))),
//
//     );
//   }
// }

import 'package:flutter/material.dart';

class Goal {
  String name;
  IconData icon;
  int progress;
  int goal;
  bool isDaily;

  Goal({
    required this.name,
    required this.icon,
    this.progress = 0,
    required this.goal,
    required this.isDaily,
  });
}

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List<Goal> goals = [];
  IconData selectedIcon = Icons.directions_run;
  String goalName = '';
  int frequency = 1;
  bool isDaily = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Goals"),
      ),
      body: ListView.builder(
        itemCount: goals.length,
        itemBuilder: (context, index) {
          Goal goal = goals[index];
          return ListTile(
            leading: Icon(goal.icon),
            title: Text(goal.name),
            subtitle: Text('Progress: ${goal.progress}/${goal.goal}'),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  goal.progress++;
                  if (goal.progress > goal.goal) {
                    goal.progress = 0;
                  }
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        tooltip: 'Add Goal',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Goal'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose Icon:'),
              _buildIconDropdown(),
              TextField(
                decoration: InputDecoration(labelText: 'Goal Name'),
                onChanged: (value) {
                  goalName = value;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Frequency'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        frequency = int.tryParse(value) ?? 1;
                      },
                    ),
                  ),
                  Text(' times per ${isDaily ? 'day' : 'week'}'),
                ],
              ),
              Row(
                children: [
                  Text('Daily Goal?'),
                  Switch(
                    value: isDaily,
                    onChanged: (value) {
                      setState(() {
                        isDaily = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  goals.add(
                    Goal(
                      name: goalName,
                      icon: selectedIcon,
                      goal: frequency,
                      isDaily: isDaily,
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: Text('Add Goal'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIconDropdown() {
    return DropdownButton<IconData>(
      value: selectedIcon,
      items: [
        DropdownMenuItem(
          value: Icons.directions_run,
          child: Row(
            children: [
              Icon(Icons.directions_run),
              SizedBox(width: 8.0),
              Text('Running'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: Icons.local_drink,
          child: Row(
            children: [
              Icon(Icons.local_drink),
              SizedBox(width: 8.0),
              Text('Water'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: Icons.bedtime,
          child: Row(
            children: [
              Icon(Icons.bedtime),
              SizedBox(width: 8.0),
              Text('Sleep'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: Icons.fastfood,
          child: Row(
            children: [
              Icon(Icons.fastfood),
              SizedBox(width: 8.0),
              Text('Healthy Eating'),
            ],
          ),
        ),
        // Add more icons as needed
      ],
      onChanged: (value) {
        setState(() {
          selectedIcon = value!;
        });
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GoalsPage(),
  ));
}
