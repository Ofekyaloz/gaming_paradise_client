import 'package:flutter/material.dart';

class GameItem extends StatelessWidget {
  final String name;

  const GameItem(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    text: name),
              ),
            )
          ],
        ),
      ),
    );
  }
}
