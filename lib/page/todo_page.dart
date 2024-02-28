// import 'package:flutter/material.dart';
//
// class TodoPage extends StatefulWidget {
//   const TodoPage({super.key});
//
//   @override
//   State<TodoPage> createState() => _TodoPageState();
// }
//
// class _TodoPageState extends State<TodoPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("ToDo"),
//         ),
//         body:
//         Center(
//             child:
//             Text('TODO', style: TextStyle(fontSize: 60))),
//     );
//   }
// }


import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<String> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Add Task',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Implement adding task functionality here
                  },
                ),
              ),
              onSubmitted: (value) {
                // Implement adding task functionality here
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                  // Implement task completion functionality here
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
