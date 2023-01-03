import 'package:flutter/material.dart';

class GameItem extends StatelessWidget {
  final String Name;
  final String ReleaseYear;
  final String Developer;
  final String Publisher;
  final int MaxPlayers;
  final String ESRB;
  final String OverView;

  GameItem(this.Name, this.ReleaseYear, this.Developer, this.Publisher,
      this.MaxPlayers, this.ESRB, this.OverView);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 200,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.amber),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              Name,
              style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                strutStyle: StrutStyle(fontSize: 12.0),
                text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    text: OverView),
              ),
            )
          ],
        ),
      ),
    );
  }
}
