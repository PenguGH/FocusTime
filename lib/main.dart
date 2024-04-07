import 'package:flutter/material.dart';
import 'package:focus_time/page/habits_home_page.dart';
// import 'package:focus_time/page/music_page.dart';
import 'package:focus_time/page/pomodoro_page.dart';
import 'package:focus_time/page/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusTime',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FocusTime Logo Here'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _currentPageIndex = 0;
  // this index keeps track of the current page you're on
  int _currentIndex = 0;

  // initialize it to be 0 at the beginning
  int _selectedIndex = 0;

  // method
  void _navigateBottomBar(int index) {
    // knows the index user is clicking
    // if user clicks on the bottom nav buttons, sets state and changes index to match the one that is most recently selected
    setState(() {
      _selectedIndex = index;
    });
  }

  // to access different screens of the app
  final screens = [
    // can always add more pages/screens later
    GoalsPage(), // Goals = To achieve something long term that you set out to accomplish.
    // A way to achieve those goals, is by building habits. Ideally short term habits overtime build up into Long term Habits that stick and become part of your daily life and routine.
    TodoPage(),
    // MusicPage(),
    PomodoroPage(),
  ];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // to show the current page's title
            Expanded(child: screens[_currentIndex]),
        // Text(
        //   'Counter: $_counter',
        //   style: TextStyle(fontSize: 20),
        // ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // fixed to see all navigation bar text and icons at once, instead of only the current 1
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[300],
        selectedItemColor: Colors.black, // the currently selected page
        unselectedItemColor: Colors.black45, // the other pages
        iconSize: 40,
        selectedFontSize: 17,
        unselectedFontSize: 15,
        currentIndex: _currentIndex,
        // currentIndex: _currentPageIndex,
        // handler onTap is used to save the current page index as the highlighted one, when icon is pressed
        // does not use background colors
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Habits",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: "Todo",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.library_music_sharp),
          //   label: "Music",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled_rounded),
            label: "Pomodoro",
          ),
        ],

      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


