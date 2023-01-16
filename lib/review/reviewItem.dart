import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  final String? username;
  final String body;

  ReviewItem(this.username, this.body);


  // Show a review in a list
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.blueGrey),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                strutStyle: const StrutStyle(fontSize: 12.0),
                text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    text: username),
              ),
            ),
            Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                // maxLines: 3,
                strutStyle: const StrutStyle(fontSize: 12.0),
                text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    text: body),
              ),
            )
          ],
        ),
      ),
    );
  }
}
