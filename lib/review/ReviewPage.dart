import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entities/Review.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage(this.review, {super.key});

  Review review;

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

// Show the review data
class _ReviewPageState extends State<ReviewPage> {
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
                    padding:
                        EdgeInsets.fromLTRB(10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                        width: double.infinity,
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          const SizedBox(height: 20),

                          // Write the username if exists
                          widget.review.UserName != null
                              ? Text(
                                  widget.review.UserName!,
                                  softWrap: true,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink),
                                )
                              : const SizedBox(),
                          widget.review.UserName != null
                              ? const SizedBox(height: 20)
                              : const SizedBox(),
                          Text(
                            "Created: ${widget.review.TimestampCreated}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                          const SizedBox(height: 20),
                          InputDecorator(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11.0),
                              )),
                              child: Text(widget.review.Content,
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ))),
                          const SizedBox(height: 30)
                        ]))))));
  }
}
