// import 'package:flutter/material.dart';
//
// class MusicPage extends StatefulWidget {
//   const MusicPage({Key? key}) : super(key: key);
//
//   @override
//   State<MusicPage> createState() => _MusicPageState();
// }
//
// class _MusicPageState extends State<MusicPage> {
//   List<String> musicList = [
//     "Song 1",
//     "Song 2",
//     "Song 3",
//     "Song 4",
//     // Add more songs later
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Music"),
//       ),
//       body: ListView.builder(
//         itemCount: musicList.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: Icon(Icons.music_note),
//             title: Text(musicList[index]),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.play_arrow),
//                   onPressed: () {
//                     // Implement play functionality
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.pause),
//                   onPressed: () {
//                     // Implement pause functionality
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
