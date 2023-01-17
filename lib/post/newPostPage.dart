import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewPost extends StatefulWidget {
  NewPost(this.gameId, {super.key});

  String gameId;

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String? error;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  Future<void> createPost() async {
    // if the content of the post is valid send to the server post request
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${Constants.url}posts/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // post data
        body: jsonEncode(<String, String>{
          'UserId': Constants.userid!,
          'Title': titleController.text,
          'GameId': widget.gameId,
          'Content': contentController.text,
        }),
      );
      // if created return to the last page
      if (response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pop(context);
        return;

        // if failed show error
      } else {
        setState(() {
          error = "Failed to create a new post.";
        });
        throw Exception('Failed to register.');
      }
    }
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

        // return button
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
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        SizedBox(height: 30),
                        Text(
                          "New Post",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [

                            // title input
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              controller: titleController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Title',
                              ),

                              // Validations
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Title can\'t be empty';
                                }
                                if (text.length < 3) {
                                  return 'Title must be 3 characters or longer!';
                                }
                                if (text.length > 50) {
                                  return 'Title must be 50 characters or shorter!';
                                }

                                return null;
                              },
                              onChanged: (text) => setState(() => _name = text),
                            ),
                            const SizedBox(height: 20),

                            // Content input
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100),
                              ],
                              minLines: 5,
                              maxLines: 20,
                              controller: contentController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Content',
                              ),
                              // Validations
                              validator: (text) {
                                if (text == null || text == "") {
                                  return 'Content can\'t be empty';
                                }
                                if (text.length < 6) {
                                  return 'Content must be 6 characters or longer!';
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() => _name = text),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Container(
                                padding: const EdgeInsets.only(top: 3, left: 3),

                                // Create Post button
                                child: MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: _name.isNotEmpty ? createPost : null,
                                    color: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Create Post",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Icon(Icons.post_add)
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Back button (exit)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          child: const Text(
                            'back',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
