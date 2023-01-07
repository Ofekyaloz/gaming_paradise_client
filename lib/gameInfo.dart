import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'entities/Game.dart';

class GameInfo extends StatefulWidget {
  GameInfo(this.game, {super.key});

  Game game;

  @override
  _GameInfoState createState() => _GameInfoState();
}

class _GameInfoState extends State<GameInfo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                width: double.infinity,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  const SizedBox(height: 20),
                  Text(
                    widget.game.Name,
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                  const SizedBox(height: 20),
                  widget.game.Developer != null
                      ? Text(
                          "By ${widget.game.Developer}",
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlueAccent),
                        )
                      : const SizedBox(),
                  widget.game.Developer != null ? const SizedBox(height: 20) : const SizedBox(),
                  widget.game.ReleaseYear != null
                      ? Text(
                          "ReleaseYear: ${widget.game.ReleaseYear}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                        )
                      : const SizedBox(),
                  widget.game.ReleaseYear != null ? const SizedBox(height: 20) : const SizedBox(),
                  Text(
                    "MaxPlayers: ${widget.game.MaxPlayers}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "ESRB: ${widget.game.ESRB}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 20),
                  InputDecorator(
                      decoration: InputDecoration(
                        border: widget.game.OverView != null
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11.0),
                              )
                            : InputBorder.none,
                      ),
                      child: widget.game.OverView != null
                          ? Text(widget.game.OverView!,
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 20,
                              ))
                          : const SizedBox()),
                  const SizedBox(height: 30)
                ]))));
  }
}
