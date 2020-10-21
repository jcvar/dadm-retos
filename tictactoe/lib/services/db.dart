import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // collection reference
  final CollectionReference gamesCollection =
      FirebaseFirestore.instance.collection('games');

  Future<bool> enterGame(String gameid) async {
    DocumentSnapshot gameSnap = await gamesCollection.doc(gameid).get();
    if (gameSnap.exists) {
      print('Game exists, checking players');
      return await tryJoinGame(gameid, gameSnap.data());
    } else {
      print('Creating game');
      return await createGame(gameid);
    }
  }

  Future<bool> tryJoinGame(String gameid, Map<String, dynamic> game) async {
    final SharedPreferences prefs = await _prefs;

    String uid = prefs.getString('uid');
    if (game['player1'] == uid) {
      print('Rejoin as player 1');
      await prefs.setBool('is_player1', true);
    } else if (game['player2'] == uid) {
      print('Rejoin as player 2');
      await prefs.setBool('is_player1', false);
    } else if (game['player2'] == null) {
      print('Join as player 2');
      await gamesCollection.doc(gameid).update({'player2': uid});
      await prefs.setBool('is_player1', false);
    } else {
      await prefs.setBool('is_player1', null); // Game is full
      return false;
    }
    return true;
  }

  Future<bool> createGame(String gameid) async {
    final SharedPreferences prefs = await _prefs;

    try {
      await gamesCollection.doc(gameid).set({
        'player1': prefs.getString('uid'),
        'board': List<int>(9),
        'turn': true,
        'score1': 0,
        'score2': 0,
        'winner': null,
      });
      await prefs.setBool('is_player1', true);
      print('Joined as player 1');
      return true;
    } on Exception catch (e) {
      print('Error creating game' + e.toString());
      return false;
    }
  }

  Stream<DocumentSnapshot> gameState(gameid) {
    return gamesCollection.doc(gameid).snapshots();
  }

  Future<void> resetGame(gameid, winner) async {
    await gamesCollection.doc(gameid).update({
      'board': List<int>(9),
      'winner' : null,
      'turn' : winner,
      winner ? 'score1' : 'score2': FieldValue.increment(1),
    });
  }
  Future<void> tieGame(gameid) async {
    await gamesCollection.doc(gameid).update({
      'board': List<int>(9),
      'winner': null,
    });
  }

  void makePlay(gameid, brd, plyr) async {
    await gamesCollection.doc(gameid).update({
      'board': brd,
      'turn': plyr,
    });
  }

  void setWinner(gameid, winner) async {
    await gamesCollection.doc(gameid).update({
      'winner' : winner,
    });
  }
}
