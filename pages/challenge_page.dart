import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/avatar_widget.dart';
import 'leaderboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChallengePage extends StatefulWidget {
  final String challengeId;
  ChallengePage({required this.challengeId});

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  Future<void> _joinChallenge() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var challengeRef = FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId);
    var snapshot = await challengeRef.get();
    List participants = snapshot['participants'];
    if (!participants.contains(uid)) {
      participants.add(uid);
      await challengeRef.update({'participants': participants});
    }
  }

  @override
  Widget build(BuildContext context) {
    var challengeRef = FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId);
    return Scaffold(
      appBar: AppBar(title: Text('Challenge')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: challengeRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var data = snapshot.data!;
          List participants = data['participants'];
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(data['title'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(onPressed: _joinChallenge, child: Text('Rejoindre')),
              Expanded(
                child: ListView.builder(
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: FirebaseFirestore.instance.collection('users').doc(participants[index]).get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return SizedBox();
                        var user = snapshot.data!;
                        return ListTile(
                          leading: AvatarWidget(avatarName: user['avatar']),
                          title: Text(user['pseudo']),
                          trailing: Text('Score: ${user['score']}'),
                        );
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LeaderboardPage()));
                  },
                  child: Text('Voir classement'))
            ],
          );
        },
      ),
    );
  }
}