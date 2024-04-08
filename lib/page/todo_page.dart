import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

// A To do list can help keep track of what needs to be done, and get some tasks done today. TodoLists help Improve productivity.
// Checkmark the tasks you have finished.
// Edit or delete existing tasks!
class Task {
  // properties of each task
  String name; // name of the task
  String dueDate; // when the task needs to be done by
  Color color; // to visually separate goals
  bool isSwipedLeft; // to determine isSwipedLeft property (used for edit/delete gestures)
  bool isChecked; // to determine if the task is done or not

  Task({
    // required fields
    required this.name,
    required this.dueDate,
    required this.color,
    this.isSwipedLeft = false, // Initialize isSwipedLeft to false by default
    this.isChecked = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      dueDate: json['dueDate'],
      isChecked: json['isChecked'],
      color: Color(json['color']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dueDate': dueDate,
      'isChecked': isChecked,
      'color': color.value,
    };
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // default values used if the user does not fill in all parts of the form
  List<Task> tasks = [];
  String taskName = '';
  String dueDate = '';
  Color selectedColor = Colors.yellow.shade100;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadTasksFromLocal();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          // getting the device's screen width
          double screenWidth = MediaQuery.of(context).size.width;

          // adjusting tasks to different screen sizes with MediaQuery
          // Calculates the size based on the screens width
          double boxWidth = screenWidth * 0.8; // 80% of the screen width
          double boxHeight = 75; // height of each listView task item

          Task task = tasks[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            // Adds vertical padding between tasks to separate them
            // to add spacing to the left and right sides of each task. makes each task more prominent

            // extra outer layer card tile
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),   // changes border radius
              ),
              child: Container(
                // height: 80,
                // Sets the height and width to match that of each task item
                width: boxWidth,
                height: boxHeight,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: screenWidth * 0.1), // 10% of the screen width as horizontal margin
                // gesture options for each task. edit (swipe right) and delete (swipe left)
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actions: [
                    Container(
                      height: boxHeight,
                      // Sets the height to match the height of each task item
                      child: IconSlideAction(
                        caption: 'Edit',
                        color: Colors.blue,
                        icon: Icons.edit,
                        onTap: () => _editTask(task),
                      ),
                    ),
                  ],
                  secondaryActions: [
                    Container(
                      height: boxHeight,
                      // Sets the height to match the height of each task item
                      child: IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => _deleteTask(task),
                      ),
                    ),
                  ],
                  child: ListTile(
                    tileColor: task.color,
                    // Sets the tileColor to the color property of the task
                    title: Text(task.name),
                    subtitle: Text(
                      task.dueDate.isNotEmpty ? 'Deadline: ${task.dueDate}' : 'No Deadline Specified',
                    ),
                    // keep track of done tasks by clicking the checkbox
                    leading: Checkbox(
                      value: task.isChecked,
                      onChanged: (bool? newValue) {
                        if(newValue != null) { // check for nullability
                          // update state
                          setState(() {
                            task.isChecked = newValue;
                          });
                        }
                        _saveTasksToLocal(); // update checkmark task status to device
                      },
                    ),
                  ),
                ),
              ),
            ), // extra ) for rounded edges
          );
        },
      ),
      // floating action button used to add a new task
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }

  void _editTask(Task task) {
    // the logic for editing an existing task

    // Creating a new temporary working copy of the og task object for editing to not affect the original data until changes are officially saved.
    // editedTask object saves all working changes.
    // If editing a task is canceled, the original data will remain unchanged.
    Task editedTask = Task(
      // getting the og properties of the task you want to edit, before any changes are made
      name: task.name,
      dueDate: task.dueDate,

      // other required attributes of a task.
      isChecked: task.isChecked,

      // currently these cannot be edited, but I might make these available for editing in the future.
      // currently just delete the task and create a new one for the same effect.
      color: task.color,
    );

    // if two objects are using the same text editing controller, it causes the cursor to move to the beginning of the textbox when typing.
    // separate text editing controllers for each TextField entry. this stops the cursor from always moving to the beginning when typing.
    // initializes each instance with the correct text field data and maintains its current cursor position.
    TextEditingController editedTaskNameController = TextEditingController(text: editedTask.name); // uses the current edited task name as placeholder.
    TextEditingController editedDueDateController = TextEditingController(text: editedTask.dueDate); // uses the current edited due date as placeholder.

    // editing task dialog/form
    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder to update immediately upon successful changes saved
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Edit Task'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editedTaskNameController,
                    onChanged: (value) {
                      setState(() {
                        editedTask.name = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'New Task Name'),
                  ),
                  TextField(
                    controller: editedDueDateController,
                    onChanged: (value) {
                      setState(() {
                        editedTask.dueDate = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'New Due Date'),
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
                    // Save all changes made to the original task
                    setState(() {
                      // Logic for saving edit changes. Changes will only be saved if there were changes made and this Save Changes button was pressed.
                      // sets the original task data to the edited task data
                      task.name = editedTask.name;
                      task.dueDate = editedTask.dueDate;

                      // Save all edited changes to local storage
                      _saveTasksToLocal();
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

  void _deleteTask(Task task) {
    // just removes the task from screen/device
    setState(() {
      tasks.remove(task); // Remove the task from the list
    });
    _saveTasksToLocal(); // Save the updated tasks list
  }

  // new task form with the most color options. dialog = form.
  // improved color picker by adding 10 shades for each color
  // 190 total color options available now!
  void _showAddTaskDialog(BuildContext context) {
    // Initializes default variables for form fields if the user did not provide any.
    String taskName = '';
    String dueDate = '';
    Color selectedColor = Colors.yellow.shade100; // good color for notes/tasks by default
    bool isChecked = false;

    // other colors for tasks are also an option. helpful for setting priority of tasks by using different colors and associations.
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

    // Main dialog/form content to add a new task/habit to the existing list
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add New Task'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Task Name'),
                    onChanged: (value) {
                      setState(() {
                        taskName = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Due Date'),
                    onChanged: (value) {
                      setState(() {
                        dueDate = value;
                      });
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      _selectColorStep(setState);
                    },
                    child: Text('Select Color (Optional)'),
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
                      // Creates a new Task object and adds it to the existing tasks list
                      tasks.add(
                        Task(
                          name: taskName,
                          dueDate: dueDate,
                          color: selectedColor,
                          isChecked: isChecked,
                        ),
                      );
                      // print('Number of tasks after adding: ${tasks.length}'); // to check if adding tasks works properly
                      _saveTasksToLocal(); // Save the updated tasks list
                      Navigator.pop(context); // Close the dialog
                    });
                  },
                  child: Text('Add Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // saving and loading data from local storage on device
  void _saveTasksToLocal() {
    SharedPreferences.getInstance().then((prefs) {
      List<String> tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
      prefs.setStringList('tasks', tasksJson).then((_) {
        setState(() {
          // Rebuilds the UI in real time after adding and saving tasks to the list
        });
      }).catchError((error) {
        print('Error saving tasks to your device local storage: $error');
      });
    }).catchError((error) {
      print('Error accessing your device local storage: $error');
    });
  }

  Future<void> _loadTasksFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasksJson = prefs.getStringList('tasks');
    if (tasksJson != null) {
      setState(() {
        tasks = tasksJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
      });
    }
  }
}