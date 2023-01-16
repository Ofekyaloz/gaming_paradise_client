import 'dart:math';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:like_button/like_button.dart';
import '../entities/Post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';
import '../entities/Comment.dart';

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
  late List<Comment> commentList;
  late bool liked;

  @override
  initState() {
    super.initState();

    // check if the user that connected create this psot
    editor = widget.post.UserName == Constants.username;

    commentList = [];
    fetchComments();
    liked = false;
    showIfLiked();
  }

  // Fetch the number of likes of the current post
  Future<String> fetchLikes() async {
    final response = await http.get(Uri.parse('${Constants.url}posts/${widget.post.Id}/likes/'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load likes');
    }
  }

  // Fetch the number of comment of the current post
  Future<String> fetchNumOfComments() async {
    final response =
        await http.get(Uri.parse('${Constants.url}posts/${widget.post.Id}/comment/amount/'));
    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      throw Exception('Failed to load num of comments');
    }
  }

  // Fetch the comments of the current post
  Future<void> fetchComments() async {
    try {
      final response =
          await http.get(Uri.parse('${Constants.url}posts/${widget.post.Id}/comment/'));
      List responseList = json.decode(response.body);
      List<Comment> tmpList = responseList.map((data) => Comment.fromJson(data)).toList();

      // Saves all the comments in commentList
      setState(() {
        commentList = [];
        commentList.addAll(tmpList);
      });
    } catch (e) {
      print("error --> $e");
    }
  }

  // Send to the server delete post request
  delPost() async {
    final respone = await http
        .delete(Uri.parse('${Constants.url}posts/${widget.post.Id}/'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (respone.statusCode != 200) {
      setState(() {
        error = "Failed to delete.";
      });
      throw Exception('Failed to delete.');

      // if succeed, return to the last page
    } else {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  // Send to the server update post request with the new content
  updatePost() async {
    // Validations
    if (title.isNotEmpty && title.length > 3) {
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

    // Sending the request
    final response = await http.put(
      Uri.parse('${Constants.url}posts/${widget.post.Id}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'Title': title, 'Content': content, 'User_id': Constants.userid!}),
    );

    if (response.statusCode == 200) {
      if (!mounted) return;
      return;

      // if failed to edit return an error
    } else {
      setState(() {
        error = "Failed to edit.";
      });
      throw Exception('Failed to edit.');
    }
  }

  // Send to the server a new comment to the current post.
  sendComment() async {
    // if content not valid return
    if (!formKey.currentState!.validate()) {
      return;
    }

    final response = await http.post(
      Uri.parse('${Constants.url}posts/${widget.post.Id}/comment/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'PostId': widget.post.Id.toString(),
        'Content': commentController.text,
        'User_id': Constants.userid.toString(),
      }),
    );

    // if succeed clear the field and update the comments
    if (response.statusCode == 200) {
      if (!mounted) return;
      commentController.clear();
      FocusScope.of(context).unfocus();
      setState(() {
        fetchComments();
      });
      return;
    } else {
      setState(() {
        error = "Failed to send the response.";
      });
      throw Exception('Failed to send the response..');
    }
  }

  // if error is not null, shows the error
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
                child: Text(error.toString(), style: const TextStyle(fontWeight: FontWeight.bold))),
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

  // if the user that connected is not editor return
  Widget editButton() {
    if (!editor) {
      return const SizedBox();
    }

    // if is edit mode shows the next buttons: save, exit and delete.
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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

                // show are you sure to delete dialog
                final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content: const Text('This action will permanently delete this post'),
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

                // check if the user continue or cancel the delete
                if (result == null || !result) {
                  return;
                }
                // del the posts and exit from edit mode
                delPost();
                setState(() {
                  _isEditMode = !_isEditMode;
                });
              },
              color: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              child: const Text(
                "DELETE",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )),
          const SizedBox(
            height: 20,
          )
        ],
      );
    }

    // Show edit post button
    return MaterialButton(
      minWidth: 90,
      height: 60,
      onPressed: () {
        setState(() {
          title = widget.post.Title;
          content = widget.post.Content;
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

  // if the user in edit mode, show the text in text filed for editing else regular text.
  Widget editData(String str, TextStyle style, String label) {
    if (_isEditMode) {
      return TextFormField(
        decoration: InputDecoration(border: const OutlineInputBorder(), labelText: label),
        style: const TextStyle(fontSize: 15),
        initialValue: str,
        maxLines: max((str.length / 10).floor(), 10),
        minLines: min((str.length / 10).floor() + 1, 2),
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

  // Show the comments of the current post
  Widget showComments() {
    if (commentList.isEmpty) {
      return const SizedBox();
    }
    return Container(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: commentList.length,
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
          );
        },
        itemBuilder: (context, index) {
          final Comment comment = commentList[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: const BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(50))),

                  // show user icon
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: 'assets/icon-user-default.png')),
                ),
              ),

              // show the user name and next to him the comment
              title: Text(
                comment.UserName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(comment.Content),
              trailing: Text(comment.TimestampCreated, style: const TextStyle(fontSize: 12)),
            ),
          );
        },
      ),
    );
  }

  // Return if the user liked this post and update the liked variable
  Future<void> showIfLiked() async {
    final response =
        await get(Uri.parse("${Constants.url}posts/${widget.post.Id}/likes/${Constants.userid}"));
    if (response.statusCode == 200) {
      setState(() {
        liked = true;
      });
    } else {
      setState(() {
        liked = false;
      });
    }
  }

  // Send to the server request to add like to the current post and update the value of liked
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    final response = await http.post(
      Uri.parse('${Constants.url}posts/${widget.post.Id}/likes/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'User_id': Constants.userid.toString(),
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        showIfLiked();
      });
    } else {
      setState(() {
        showIfLiked();
      });
    }
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
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: double.infinity,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  showAlert(),
                  const SizedBox(height: 20),
                  Text(
                    "${widget.post.GameName}: ",
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink),
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
                        fontSize: 25, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Created: ${widget.post.TimestampCreated}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
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
                            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                        "Content"),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    Row(
                      children: [
                        // like button
                        LikeButton(
                          isLiked: liked,
                          onTap: onLikeButtonTapped,
                        ),
                        // write the number of likes
                        FutureBuilder<String>(
                          future: fetchLikes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!.toString());
                            }
                            return const Text("0");
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // show the number of comments
                        const Icon(Icons.comment_rounded),
                        FutureBuilder<String>(
                          future: fetchNumOfComments(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!.toString());
                            }
                            return const Text("0");
                          },
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 30),
                  // edit button
                  editButton(),
                  const SizedBox(height: 20),

                  // Comment box
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          minLines: 3,
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

                        // send comment button
                        SizedBox(
                          width: 110,
                          child: MaterialButton(
                              height: 60,
                              onPressed: commentController.text.isNotEmpty ? sendComment : null,
                              color: Colors.pink,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Text(
                                    "Send",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(Icons.send)
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // List of comments
                  InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      child: showComments()),
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
