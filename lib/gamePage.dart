// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:like_button/like_button.dart';
// import 'entities/Game.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'entities/Post.dart';
// import 'utils.dart';
//
// class gamePage extends StatefulWidget {
//   gamePage(this.game, {super.key});
//
//   Game game;
//
//   @override
//   State<gamePage> createState() => _gamePageState();
// }
//
// class _gamePageState extends State<gamePage> {
//   late Future<List<Post>> posts;
//
//   @override
//   void initState() {
//     super.initState();
//     posts = fetchPosts();
//   }
//
//   // Future<String> fetchLikes() async {
//   //   final response =
//   //   await http.get(Uri.parse('${Constants.url}posts/${widget.post.Id}/likes/'));
//   //   if (response.statusCode == 200) {
//   //     return response.body;
//   //   } else {
//   //     throw Exception('Failed to load likes');
//   //   }
//   // }
//
//   Future<List<Post>> fetchPosts() async {
//     final response =
//     await http.get(Uri.parse('${Constants.url}games/${widget.game.Name}/'));
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((data) => Post.fromJson(data)).toList();
//     } else {
//       throw Exception('Failed to load likes');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.blue,
//         title: const Text('Gaming Paradise!'),
//         centerTitle: true,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               size: 20,
//               color: Colors.black,
//             )),
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(
//                 10, 10, 10, MediaQuery
//                 .of(context)
//                 .viewInsets
//                 .bottom),
//             child: Container(
//               width: double.infinity,
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     const SizedBox(height: 20),
//                     Text(
//                       widget.game.Name,
//                       softWrap: true,
//                       style: const TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.pink),
//                     ),
//                     const SizedBox(height: 10),
//                     widget.game.Developer != null ? Text(
//                       "By ${widget.game.Developer}",
//                       softWrap: true,
//                       style: const TextStyle(
//                           fontSize: 25,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.lightBlueAccent),
//                     ) : const SizedBox(),
//
//                     widget.game.Developer != null ? const SizedBox(height: 20) : const SizedBox(),
//                     Text(
//                       "Created: ${widget.post.TimestampCreated}",
//                       style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey),
//                     ),
//                     const SizedBox(height: 40),
//
//                     InputDecorator(
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(11.0))
//                       ),
//                       child: Text(widget.game.OverView,
//                            TextStyle(
//                               fontSize: 25,
//                               fontWeight: FontWeight.bold)),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//
//                     ),
//                   ]),
//               const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }