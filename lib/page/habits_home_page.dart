import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class Goal {
  // properties of each goal
  String name;
  String unitName;
  IconData icon;
  int progress;
  int goal;
  bool isDaily;
  Color color;
  bool isSwipedLeft; // to determine isSwipedLeft property (used for edit/delete gestures)
  Goal({
    required this.name,
    required this.unitName,
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
      unitName: json['unitName'],
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
      'unitName': unitName,
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
  String unitName = '';
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
                    subtitle: Text('Progress: ${goal.progress}/${goal.goal} ${goal.unitName} (${goal.isDaily ? 'Daily' : 'Weekly'})'),
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
    // the logic for editing an existing goal

    // Creating a new temporary working copy of the og goal object for editing to not affect the original data until changes are officially saved.
    // editedGoal object saves all working changes.
    // If editing a goal is canceled, the original data will remain unchanged.
    Goal editedGoal = Goal(
      // getting the og properties of the goal you want to edit, before any changes are made
      name: goal.name,
      unitName: goal.unitName,
      progress: goal.progress,

      // if I want to make these available for editing in the future
      icon: goal.icon,
      goal: goal.goal,
      isDaily: goal.isDaily,
      color: goal.color,
    );

    // if two objects are using the same text editing controller, it causes the cursor to move to the beginning of the textbox when typing.
    // separate text editing controllers for each TextField entry. this stops the cursor from always moving to the beginning when typing.
    // initializes each instance with the correct text field data and maintains its current cursor position.
    TextEditingController editedGoalNameController = TextEditingController(text: editedGoal.name); // uses the current edited goal name as placeholder.
    TextEditingController editedUnitNameController = TextEditingController(text: editedGoal.unitName); // uses the current edited unit name as placeholder.

    // editing goal dialog/form
    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder to update immediately upon successful changes saved
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Edit Goal'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editedGoalNameController,
                    onChanged: (value) {
                      setState(() {
                        editedGoal.name = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'New Goal Name'),
                  ),
                  TextField(
                    controller: editedUnitNameController,
                    onChanged: (value) {
                      setState(() {
                        editedGoal.unitName = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'New Unit Name'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Logic for resetting progress data; just resets it back to 0.
                          editedGoal.progress = 0;

                          // automatically reset progress upon onPressed and saves changes. (implicitly saves data)
                          // _saveGoalsToLocal();
                        });
                      },
                      child: Text('Reset Progress'),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  // cancels all editing changes and discards them
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Save all changes made to the original goal
                    setState(() {
                      // Logic for saving edit changes. Changes will only be saved if there were changes made and this Save Changes button was pressed.
                      // sets the original goal data to the edited goal data
                      goal.name = editedGoal.name;
                      goal.unitName = editedGoal.unitName;
                      goal.progress = editedGoal.progress;

                      // Save all edited changes to local storage
                      _saveGoalsToLocal();
                      Navigator.pop(context);
                    });
                  },
                  // Save changes button is to (explicitly) confirm changes before altering the data.
                  child: Text('Save Changes'),
                ),
              ],
            );
          },
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

  // new goal form with the most color options. dialog = form.
  // improved color picker by adding 10 shades for each color
  // 190 total color options available now!
  void _showAddGoalDialog(BuildContext context) {
    // Initializes default variables for form fields if the user did not provide any.
    String goalName = '';
    String unitName = '';
    int frequency = 1;
    bool isDaily = false;
    Color selectedColor = Colors.lightBlueAccent;
    // color selection dialog
    // Function to navigate to the color selection step
    void _selectColorStep(StateSetter setState) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Choose Color'),
            content: MaterialColorPicker(
              onColorChange: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
              selectedColor: selectedColor,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true); // Return true to indicate color selection is finished
                },
                child: Text('Done'),
              ),
            ],
          );
        },
      );
    }
    // Main dialog/form content to add a new goal/habit to the existing list
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add New Goal'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Choose Icon:'),
                  _buildIconDropdownWidget(setState), // Function to build the icon dropdown menu
                  TextField(
                    decoration: InputDecoration(labelText: 'Goal Name'),
                    onChanged: (value) {
                      setState(() {
                        goalName = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Unit Name'),
                    onChanged: (value) {
                      setState(() {
                        unitName = value;
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
                  TextButton(
                    onPressed: () {
                      _selectColorStep(setState);
                    },
                    child: Text('Select Color'),
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
                      // Creates a new Goal object and adds it to the existing goals list
                      goals.add(
                        Goal(
                          name: goalName,
                          unitName: unitName,
                          icon: selectedIcon ?? Icons.directions_run, // Uses the user selectedIcon here. Otherwise it uses the default icon if none is selected.
                          goal: frequency,
                          isDaily: isDaily,
                          color: selectedColor,
                        ),
                      );
                      print('Number of goals after adding: ${goals.length}'); // to check if adding goals works properly
                      _saveGoalsToLocal(); // Save the updated goals list
                      Navigator.pop(context); // Close the dialog
                    });
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

  // used to select an icon and goal type
  // 5 common icons/goal types to start. and 1 icon (other) used for all other custom goals.
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
          print("Selected Icon: $selectedIcon");
        });
      },
    );
  }

  // saving and loading data from local storage on device
  void _saveGoalsToLocal() {
    SharedPreferences.getInstance().then((prefs) {
      List<String> goalsJson = goals.map((goal) => jsonEncode(goal.toJson())).toList();
      prefs.setStringList('goals', goalsJson).then((_) {
        setState(() {
          // Rebuilds the UI in real time after adding and saving goals to the list
        });
      }).catchError((error) {
        print('Error saving goals to your device local storage: $error');
      });
    }).catchError((error) {
      print('Error accessing your device local storage: $error');
    });
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

// this is the home page. aka the first page you see when you open the app.
void main() {
  runApp(MaterialApp(
    home: GoalsPage(),
  ));
}