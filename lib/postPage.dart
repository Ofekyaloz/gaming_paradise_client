import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'entities/Post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:comment_box/comment/comment.dart';
import 'utils.dart';
import 'Comment.dart';

class postPage extends StatefulWidget {
  postPage(this.post, {super.key});

  Post post;

  @override
  State<postPage> createState() => _postPageState();
}

String title = "", content = "";

class _postPageState extends State<postPage> {
  late final bool editor;
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  bool _isEditMode = false;
  String text = "";
  String? error;
  // String likes ="0";
  late Future<String> likes;
  // late Future<List> filedata;

  @override
  void initState() {
    super.initState();
    likes = fetchLikes();
    // filedata = fetchComments();
    editor = widget.post.UserName == Constants.username;
  }

  Future<String> fetchLikes() async {
    final response =
    await http.get(Uri.parse('${Constants.url}posts/${widget.post.Id}/likes/'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load likes');
    }
  }

  Future<List<Comment>> fetchComments() async {
    final response =
    await http.get(Uri.parse('${Constants.url}posts/${widget.post.Id}/response/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Comment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load likes');
    }
  }


  List comments = [{
      'name': 'Chuks Okwuenu',
      'pic': 'assets/icon-user-default.png',
      'message': 'I love to code',
      'date': '2021-01-01 12:00:00'
    }, {
      'name': 'Biggi Man',
      'pic': 'assets/icon-user-default.png',
      'message': 'Very cool',
      'date': '2021-01-01 12:00:00'
    }, {
      'name': 'Tunde Martins',
      'pic': 'assets/icon-user-default.png',
      'message': 'Very cool',
      'date': '2021-01-01 12:00:00'
    }, {
      'name': 'Biggi Man',
      'pic': 'assets/icon-user-default.png',
      'message': 'Very cool',
      'date': '2021-01-01 12:00:00'
    },];

  delPost() async {
    final respone = await http.delete(
        Uri.parse('${Constants.url}api/posts/${widget.post.Id}/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (respone.statusCode != 200) {
      setState(() {
        error = "Failed to delete.";
      });
      throw Exception('Failed to delete.');
    }
  }

  updatePost() async {
    if (title.isNotEmpty && title.length > 5) {
      widget.post.setTitle(title);
    } else {
      error = "Title can not be empty!";
      return;
    }
    if (content.isNotEmpty && content.length > 5) {
      widget.post.setContext(content);
    } else {
      error = "Content can not be empty!";
      return;
    }
    final response = await http.put(
      Uri.parse('${Constants.url}api/posts/${widget.post.Id}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Title': title,
        'Content': content,
        'UserName': 'Idog770'
      }),
    );

    if (response.statusCode == 200) {
      if (!mounted) return;
      return;
    } else {
      setState(() {
        error = "Failed to edit.";
      });
      throw Exception('Failed to edit.');
    }
  }

  sendComment() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // ofek ofek
    var value = {
      'name': Constants.username.toString(),
      'pic': 'assets/icon-user-default.png',
      'message': commentController.text,
      'date': '2021-01-01 12:00:00'
    };
    comments.insert(0, value);
    commentController.clear();
    FocusScope.of(context).unfocus();


    final response = await http.post(
      Uri.parse('${Constants.url}api/posts/${widget.post.Id}/response/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'PostId': widget.post.Id.toString(),
        'Content': commentController.text,
        'UserName': Constants.username.toString(),
      }),
    );

    if (response.statusCode == 200) {
      if (!mounted) return;
      var value = {
        'name': Constants.username.toString(),
        'pic': 'assets/icon-user-default.png',
        'message': commentController.text,
        'date': '2021-01-01 12:00:00'
      };
      // filedata.insert(0, value);
      commentController.clear();
      FocusScope.of(context).unfocus();
      return;
    } else {
      setState(() {
        error = "Failed to send the response.";
      });
      throw Exception('Failed to send the response..');
    }
  }

  Widget showAlert() {
    if (error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
                child: Text(error.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget editButton() {
    if (!editor) {
      return const SizedBox();
    }
    if (_isEditMode) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
              minWidth: 90,
              height: 60,
              onPressed: () {
                updatePost();
                setState(() {
                  _isEditMode = !_isEditMode;
                });
              },
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: const Text(
                "Save",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )),
          const SizedBox(height: 10),
          MaterialButton(
              minWidth: 90,
              height: 60,
              onPressed: () {
                setState(() {
                  _isEditMode = !_isEditMode;
                });
              },
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: const Text(
                "Exit",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )),
          const SizedBox(height: 10),
          MaterialButton(
              minWidth: 90,
              height: 60,
              onPressed: () async {
                final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content: const Text(
                              'This action will permanently delete this post'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ));

                if (result == null || !result) {
                  return;
                }

                delPost();
                setState(() {
                  _isEditMode = !_isEditMode;
                });
              },
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: const Text(
                "DELETE",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ))
        ],
      );
    }
    return MaterialButton(
      minWidth: 90,
      height: 60,
      onPressed: () {
        title = widget.post.Title;
        content = widget.post.Content;
        setState(() {
          _isEditMode = !_isEditMode;
        });
      },
      color: Colors.greenAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: const Text(
        'Edit Post',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget editData(String str, TextStyle style, String label) {
    if (_isEditMode) {
      return TextFormField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(), labelText: label),
        style: const TextStyle(fontSize: 15),
        initialValue: str,
        maxLines: max((str.length / 10).floor(), 10),
        minLines: min((str.length / 10).floor(), 2),
        onChanged: (value) {
          if (label == "Title") {
            title = value;
          } else {
            content = value;
          }
        },
      );
    } else {
      return Text(str, softWrap: true, style: style);
    }
  }

  Widget commentChild(data) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            for (var i = 0; i < data.length; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () async {
                      // Display the image in large form.
                      print("Comment Clicked");
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                              new BorderRadius.all(Radius.circular(50))),
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage: CommentBox.commentImageParser(
                              imageURLorPath: data[i]['pic'])),
                    ),
                  ),
                  title: Text(
                    data[i]['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data[i]['message']),
                  trailing:
                      Text(data[i]['date'], style: TextStyle(fontSize: 10)),
                ),
              )
          ],
        ));
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();
    // final response = await http.post(
    //   Uri.parse('${Constants.url}api/posts/${widget.post.Id}/likes/${Constants.username}'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'UserName': Constants.username.toString(),
    //   }),
    // );
    // return response.statusCode == 200? !isLiked:isLiked;

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: const Text('Gaming Paradise!'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  showAlert(),
                  const SizedBox(height: 20),
                  Text(
                    "${widget.post.GameName}: ",
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                  const SizedBox(height: 20),
                  editData(
                      widget.post.Title,
                      const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                      "Title"),
                  const SizedBox(height: 20),
                  Text(
                    "By ${widget.post.UserName}",
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Created: ${widget.post.TimestampCreated}",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  InputDecorator(
                    decoration: InputDecoration(
                      border: !_isEditMode
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11.0),
                            )
                          : InputBorder.none,
                    ),
                    child: editData(
                        widget.post.Content,
                        const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        "Content"),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            LikeButton(
                              onTap: onLikeButtonTapped,
                            ),
                            FutureBuilder<String>(
                              future: fetchLikes(),
                              builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data!.toString());
                              }
                              // else if (snapshot.hasError) {
                                // return Text('${snapshot.error}');
                              // }
                              return const Text("0");
                              // return const CircularProgressIndicator();
                            },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.comment_rounded),
                            Text(comments.length.toString())
                            // FutureBuilder<List<Comment>>(
                            //   future: filedata = fetchComments(),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.hasData) {
                            //       return Text(snapshot.data!.length.toString());
                            //     }
                            //     // else if (snapshot.hasError) {
                            //     //   return const Text("0");
                            //     // }
                            //     // By default show a loading spinner.
                            //     return const CircularProgressIndicator();
                            //   },
                            // )

                          ],
                        ),
                      ]),
                  const SizedBox(height: 40),
                  editButton(),
                  const SizedBox(height: 20),
                  Container(child: commentChild(comments)),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          minLines: 5,
                          maxLines: 20,
                          controller: commentController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Write a comment...',
                          ),
                          validator: (text) {
                            if (text == null || text == "") {
                              return 'Content can\'t be empty';
                            }
                            if (text.length < 3) {
                              return 'Content must be 3 characters or longer!';
                            }
                            return null;
                          },
                          onChanged: (input) => setState(() => text = input),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 90,
                          child: MaterialButton(
                              height: 60,
                              minWidth: 90,
                              onPressed: commentController.text.isNotEmpty
                                  ? sendComment
                                  : null,
                              color: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Send",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.send)
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}