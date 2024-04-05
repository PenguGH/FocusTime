import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class Goal {
  String name;
  IconData icon;
  int progress;
  int goal;
  bool isDaily;
  Color color;
  bool isSwipedLeft; // to determine isSwipedLeft property (used for edit/delete gestures)

  Goal({
    required this.name,
    required this.icon,
    this.progress = 0,
    required this.goal,
    required this.isDaily,
    required this.color,
    this.isSwipedLeft = false, // Initialize isSwipedLeft to false by default
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      name: json['name'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      progress: json['progress'],
      goal: json['goal'],
      isDaily: json['isDaily'],
      color: Color(json['color']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon.codePoint,
      'progress': progress,
      'goal': goal,
      'isDaily': isDaily,
      'color': color.value,
    };
  }
}

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  // default values used if the user does not fill in all parts of the form
  List<Goal> goals = [];
  IconData selectedIcon = Icons.directions_run;
  String goalName = '';
  int frequency = 1;
  bool isDaily = true;
  Color selectedColor = Colors.lightBlueAccent;

  @override
  void initState() {
    super.initState();
    _loadGoalsFromLocal();
  }

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

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            // Adds vertical padding between goals to separate them

          // to add spacing to the left and right sides of each goal. makes each goal more prominent
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),   // changes border radius
            ),

            child: Container(
              height: 80,
              // Sets the height to match the height of each goal item
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actions: [
                  Container(
                    height: 80,
                    // Sets the height to match the height of each goal item
                    child: IconSlideAction(
                      caption: 'Edit',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () => _editGoal(goal),
                    ),
                  ),
                ],
                secondaryActions: [
                  Container(
                    height: 80,
                    // Sets the height to match the height of each goal item
                    child: IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => _deleteGoal(goal),
                    ),
                  ),
                ],
                child: ListTile(
                  tileColor: goal.color,
                  // Sets the tileColor to the color property of the goal
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
                      _saveGoalsToLocal();
                    },
                  ),
                ),
              ),
            ),
           ), // extra ) for rounded edges
          );
        },
      ),
      // floating action button used to add a new goal
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        tooltip: 'Add Goal',
        child: Icon(Icons.add),
      ),
    );
  }

  void _editGoal(Goal goal) {
    // the logic of editing the goal
    // todo need to update to use same options as adding a new goal
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Goal'),
          content: TextField(
            controller: TextEditingController(text: goal.name), // Displays current goal name
            onChanged: (value) {
              setState(() {
                goal.name = value; // Update the goal name
              });
            },
            decoration: InputDecoration(labelText: 'New Goal Name'),
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
                // Save the edited goal
                _saveGoalsToLocal();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteGoal(Goal goal) {
    // just removes the goal from screen/device
    setState(() {
      goals.remove(goal); // Remove the goal from the list
    });
    _saveGoalsToLocal(); // Save the updated goals list
  }

  // new goal form with more color options
  void _showAddGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Color selectedColor = Colors.lightBlueAccent; // Initialize selectedColor

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add New Goal'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Choose Icon:'),
                  _buildIconDropdownWidget(setState),
                  TextField(
                    decoration: InputDecoration(labelText: 'Goal Name'),
                    onChanged: (value) {
                      setState(() {
                        goalName = value;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Frequency'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              frequency = int.tryParse(value) ?? 1;
                            });
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
                  Text('Choose Color:'),
                  MaterialColorPicker(
                    onColorChange: (Color color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    selectedColor: selectedColor,
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
                          color: selectedColor,
                        ),
                      );
                    });
                    _saveGoalsToLocal();
                    Navigator.pop(context);
                  },
                  child: Text('Add Goal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildIconDropdownWidget(StateSetter setState) {
    return DropdownButton<IconData>(
      value: selectedIcon,
      items: [
        DropdownMenuItem(
          value: Icons.directions_run,
          child: Row(
            children: [
              Icon(Icons.directions_run),
              SizedBox(width: 8.0),
              Text('Exercise'),
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
          value: Icons.apple,
          child: Row(
            children: [
              Icon(Icons.apple),
              SizedBox(width: 8.0),
              Text('Healthy Eating'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: Icons.work,
          child: Row(
            children: [
              Icon(Icons.work),
              SizedBox(width: 8.0),
              Text('Work'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: Icons.lightbulb,
          child: Row(
            children: [
              Icon(Icons.lightbulb),
              SizedBox(width: 8.0),
              Text('Other'),
            ],
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          selectedIcon = value!;
        });
      },
    );
  }

  void _saveGoalsToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> goalsJson = goals.map((goal) => jsonEncode(goal.toJson())).toList();
    await prefs.setStringList('goals', goalsJson);
  }

  Future<void> _loadGoalsFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? goalsJson = prefs.getStringList('goals');
    if (goalsJson != null) {
      setState(() {
        goals = goalsJson.map((json) => Goal.fromJson(jsonDecode(json))).toList();
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: GoalsPage(),
  ));
}