import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tictactoe/screens/windialog.dart';
import 'package:tictactoe/services/auth.dart';
import 'package:tictactoe/services/db.dart';
import 'package:tictactoe/services/prefs.dart';

// ignore: must_be_immutable
class GamePage extends StatefulWidget {
  String gameid;
  GamePage(this.gameid);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const String X_IMG = 'images/icon-x.png';
  static const String O_IMG = 'images/icon-o.png';
  StreamSubscription<DocumentSnapshot> gamesub;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final AuthService _auth = AuthService();
  final DataService db = DataService();

  List board = List(9);
  bool player = false;

  // Prefs
  bool soundCheck = false;
  String dffclt = '';

  bool turn;
  int wins;
  int lost;

  int winner;
  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //
  //  END STATE FIELDS                                                        //
  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //
  @override
  void initState() {
    super.initState();

    // PREFS
    initPrefs().then((value) {
      restore();
      // GAME PREFS
      playerBool();
    });

    // GAME LOGIC
    gamesub = db.gameState(widget.gameid).listen(
      (snapshot) {
        setState(() {
          board = snapshot.data()['board'];
          turn = snapshot.data()['turn'];
          wins = snapshot.data()[player ? 'score1' : 'score2'];
          lost = snapshot.data()[!player ? 'score1' : 'score2'];
          winner = snapshot.data()['winner'];

          print(winner);
          if (winner == null && turn != player)
            checkBoard(player ? 1 : 2);
          else if (winner != null) {
            winDialog(winner);
          }
        });
      },
      cancelOnError: false,
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();

    // widgetCleanup();
    await gamesub.cancel();
    print('dispose');
  }

  void widgetCleanup() async {
    await gamesub.cancel();
  }

  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //
  //  PREFERENCE FETCHING                                                     //
  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //
  restore() async {
    final SharedPreferences sharedPrefs = await _prefs;
    setState(() {
      soundCheck = (sharedPrefs.getBool('sound') ?? false);
      dffclt = (sharedPrefs.getString('difficulty') ?? 'none');
    });
  }

  void playerBool() async {
    SharedPreferences prefs = await _prefs;
    player = prefs.getBool('is_player1');
    // opponent = !player;
  }

  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //
  //  GAMEPLAY METHODS                                                        //
  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //
  moveHandler(int i) {
    // Tile press callback
    print(i);
    if (player == turn) {
      playGame(i);
    }
  }

  Future<void> playGame(int i) async {
    //GameButton gb) {
    if (soundCheck) {
      SystemSound.play(SystemSoundType.click);
    }
    if (board[i] == null) {
      //gb.enabled) {
      board[i] = player ? 1 : 2;
      db.makePlay(widget.gameid, board, !player);
    }

    // setState(() {
    //   p1.add(i);
    //   checkWinner(player, p1);
    // } else {
    //   //Timer(Duration(seconds: 1), () {
    //   Future.delayed(const Duration(milliseconds: 500), () {
    //     setState(() {
    //       // gb.text = '⭕️';
    //       gb.text = 'images/icon-o.png';
    //       // gb.bg = Colors.red;
    //       activep = player;
    //       p2.add(gb.id);
    //       checkWinner(opponent, p2);
    //     });
    //   });
    // }
    // });
    // }
  }

  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //
  //  ENDGAME METHODS                                                         //
  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //
  void checkBoard(int p) {
    int winp;
    // Check horizontally
    for (var i = 0; i < 9; i += 3) {
      if (board[i] == p && board[i + 1] == p && board[i + 2] == p) {
        winp = p;
      }
    }
    // Check vertically
    for (var i = 0; i < 3; i += 1) {
      if (board[i] == p && board[i + 3] == p && board[i + 6] == p) {
        winp = p;
      }
    }
    // Check diagonally
    if ((board[0] == p && board[4] == p && board[8] == p) ||
        (board[2] == p && board[4] == p && board[6] == p)) {
      winp = p;
    }
    if (winp == null && !board.contains(null)) {
      winp = 0;
    }
    if (winp != null) {
      db.setWinner(widget.gameid, winp);
    }
  }

  void winDialog(int win) {
    if (win != 0) {
      showDialog(
          context: context,
          builder: (_) => win == 1 && player || win == 2 && !player
              ? WinDialog(
                  'You won!', 'Press reset to start a new game', resetGame)
              : WinDialog('You lost!', 'Better luck next time', () {
                  if (Navigator.canPop(context)) Navigator.pop(context);
                }, 'Continue'));
    } else {
      showDialog(
          context: context,
          builder: (_) => turn == player
              ? WinDialog(
                  'Game Tied 🤯', 'Press reset to start a new game', resetGame)
              : WinDialog('Game Tied 🤯', 'Continue to play a new game', () {
                  if (Navigator.canPop(context)) Navigator.pop(context);
                }, 'Continue'));
    }
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    if (winner == 0) {
      db.tieGame(widget.gameid);
    } else {
      db.resetGame(widget.gameid, player);
    }
  }

  // void autoPlay() {
  //   var emptyCells = List();
  //   //var list = List.generate(9, (i) => i+1)
  //   for (var btn in buttonsList) {
  //     if (btn.enabled) {
  //       emptyCells.add(btn.id);
  //     }
  //   }

  //   var rnd = Random();
  //   var rid = emptyCells[rnd.nextInt(emptyCells.length)];
  //   int i = buttonsList.indexWhere((btn) => btn.id == rid);
  //   playGame(buttonsList[i]);
  // }

  Future<void> menuOptions(String value) async {
    switch (value) {
      case 'preferences':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PrefsPage();
            },
          ),
        ).then((value) {
          setState(() {
            restore();
          });
        });
        break;
      case 'newgame':
        resetGame();
        break;
      case 'difficulty':
        var newdffclt = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Text('Select difficulty:'),
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 'Easy');
                    },
                    child: Text('Easy'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 'Medium');
                    },
                    child: Text('Medium'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 'Hard');
                    },
                    child: Text('Hard'),
                  ),
                ],
              );
            });
        if (newdffclt == 'Easy' ||
            newdffclt == 'Medium' ||
            newdffclt == 'Hard') {
          setState(() {
            dffclt = newdffclt as String;
          });
        }
        break;
      case 'logout':
        await _auth.signOut();
        // exit(0); //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        break;
    }
  }

  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //
  //  BUILD METHOD                                                            //
  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: menuOptions,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'preferences',
                child: Text('Preferences'),
              ),
              const PopupMenuItem<String>(
                value: 'newgame',
                child: Text('New game'),
              ),
              const PopupMenuItem<String>(
                value: 'difficulty',
                child: Text('Difficulty'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Log out'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // PLAY GRID
          Expanded(
            child: //StreamBuilder<DocumentSnapshot>(
                //stream: db.gameState(widget.gameid),
                //builder: (context, snapshot) {
                //if (!snapshot.hasData) return Text('Loading board');
                //board = snapshot.data.data()['board'];
                GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 9.0,
                mainAxisSpacing: 9.0,
              ),
              itemCount: board.length,
              itemBuilder: (context, i) => SizedBox(
                width: 100.0,
                height: 100.0,
                child: RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: board[i] == null && turn == player
                      ? () {
                          moveHandler(i);
                        }
                      : null,
                  child: board[i] == null
                      ? null
                      : Image(image: AssetImage(board[i] == 1 ? X_IMG : O_IMG)),
                  color: Colors.grey,
                  disabledColor: Colors.blueGrey,
                ),
              ),
            ),
          ),
          // BOTTOM INFO
          Center(
            child: Column(
              children: [
                // LABELS
                Text(
                  'SCORE',
                  style: TextStyle(color: Colors.grey),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'won: $wins - lost: $lost',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Text(
                  'Game ID: ' + widget.gameid,
                  style: TextStyle(color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Playing as: ' + (player ? '❌' : '⭕'),
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    turn == player ? 'It\'s your turn' : 'Waiting to play',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
