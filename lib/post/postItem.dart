import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String title;
  final String body;

  PostItem(this.title, this.body);


  // A post item in a list
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
                    text: title),
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
