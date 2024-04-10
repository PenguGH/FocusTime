import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_time/main.dart';
// import 'package:focus_time/page/habits_home_page.dart';

// a cool splash screen with my FocusTime logo and app name when you open the app!
// stateful widget allows info to change, such as useful tips/hint screens seen in video games while waiting to load into the game/level.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    // allows adding duration, animations, and more to splash screens
    with SingleTickerProviderStateMixin {
 @override
 void initState() {
    //initState runs asap after the app opens, this splash screen is loaded.
    // initState is only loaded once at the very beginning upon app opening
   // if the app time outs, you will see the splash screen once again when you restart the app
    super.initState();

    // upon load, removes top and bottom nav bars. removes status bar with battery, wifi, etc. removes bottom android arrow buttons.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);


    // Future variable is created but is delayed, but the Count down starts right away. takes only a second or two. after that is finished, it returns a function/method of what to do/go to next.
    Future.delayed(Duration(seconds:2), () {
      // go to the home page (1st page in my app)
      // Navigator.push(); // to go back to previous route

      // uses navigator of the context, pushes a replacement, and routes it to the correct new page. Ex: to go to the home screen page
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        // builder context not needed. so only (_) works. no context needs to be provided in the builder.
        // only the new page we want to go to is needed and called with arrow functions notation.
        // builder: (_) => const GoalsPage(), // this would only go to 1 page
        builder: (_) => const MyHomePage(title: 'FocusTime logo here'), // This is my home page with the bottom nav bar to go to all the other pages.
      )); // replaces current route with a new route
    } );
  }

  @override
  void dispose(){
   // dispose is the opposite of the initState function.
   // when everything in this page has loaded, the events after dispose here occur next.
    // manually controls what happens next in the app.
    // Once the splash screen is done, it brings back the System Ui overlay mode top and bottom.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
   super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // makes width as big as possible on the device
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            // In the middle of the screen:
            Image(
              // successfully added an image to the splash screen
              // image: AssetImage('assets/app_icon_logo_2.png'),
              image: AssetImage('assets/app_icon_logo_2_no_background.png'),
              height: 115, // Adjusts the height of image
              width: 115, // Adjusts the width of image
            ),
            SizedBox(height: 15), // for vertical margins
            Text(
                'FocusTime',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontSize: 35,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
