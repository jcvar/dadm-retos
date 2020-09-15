import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictactoe/gamebutton.dart';
import 'package:tictactoe/windialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  var p1;
  var p2;
  var activep;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    p1 = List();
    p2 = List();
    activep = 1;

    var gameButtons = <GameButton>[
      new GameButton(id: 0),
      new GameButton(id: 1),
      new GameButton(id: 2),
      new GameButton(id: 3),
      new GameButton(id: 4),
      new GameButton(id: 5),
      new GameButton(id: 6),
      new GameButton(id: 7),
      new GameButton(id: 8),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    if (gb.enabled) {
      setState(() {
        gb.enabled = false;
        if (activep == 1) {
          gb.text = '❌';
          gb.bg = Colors.blue;
          activep = 2;
          p1.add(gb.id);
          checkWinner(1, p1);
        } else {
          gb.text = '⭕️';
          gb.bg = Colors.red;
          activep = 1;
          p2.add(gb.id);
          checkWinner(2, p2);
        }
      });
    }
  }

  void checkWinner(p, plyr) {
    var winner = 0;
    // Check horizontally
    for (var i = 0; i < 9; i += 3) {
      if (plyr.contains(i) && plyr.contains(i + 1) && plyr.contains(i + 2)) {
        winner = p;
      }
    }
    // Check vertically
    for (var i = 0; i < 3; i += 1) {
      if (plyr.contains(i) && plyr.contains(i + 3) && plyr.contains(i + 6)) {
        winner = p;
      }
    }
    // Check diagonally
    if ((plyr.contains(0) && plyr.contains(4) && plyr.contains(8)) ||
        (plyr.contains(2) && plyr.contains(4) && plyr.contains(6))) {
      winner = p;
    }

    if (winner != 0) {
      showDialog(
          context: context,
          builder: (_) => WinDialog('Player ' + p.toString() + ' won!',
              'Press reset to start a game', resetGame));
    } else {
      if (buttonsList.every((btn) => btn.enabled == false)) {
        showDialog(
            context: context,
            builder: (_) => WinDialog(
                'Game Tied 🤯', 'Press reset to start a new game', resetGame));
      } else if (activep == 2) {
        autoPlay();
      }
    }
  }

  void autoPlay() {
    var emptyCells = List();
    //var list = List.generate(9, (i) => i+1)
    for (var btn in buttonsList) {
      if (btn.enabled) {
        emptyCells.add(btn.id);
      }
    }

    var rnd = Random();
    var rid = emptyCells[rnd.nextInt(emptyCells.length)];
    int i = buttonsList.indexWhere((btn) => btn.id == rid);
    playGame(buttonsList[i]);
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 9.0,
                  mainAxisSpacing: 9.0,
                ),
                itemCount: buttonsList.length,
                itemBuilder: (context, i) => SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      onPressed: () => playGame(buttonsList[i]),
                      child: Text(
                        buttonsList[i].text,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      color: buttonsList[i].bg,
                      disabledColor: buttonsList[i].bg,
                    ))),
          ),
          RaisedButton(
              child: Text('RESET',
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
              color: Colors.yellow,
              padding: const EdgeInsets.all(20.0),
              onPressed: resetGame)
        ],
      ),
    );
  }
}
