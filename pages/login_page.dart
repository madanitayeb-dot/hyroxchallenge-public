import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/avatar_widget.dart';
import 'package:uuid/uuid.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _pseudoController = TextEditingController();

  Future<void> _login() async {
    String pseudo = _pseudoController.text.trim();
    if (pseudo.isEmpty) return;

    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    String uid = userCredential.user!.uid;

    var avatar = AvatarWidget.randomAvatar();
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'pseudo': pseudo,
      'avatar': avatar,
      'score': 0,
    });

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: _pseudoController,
              decoration: InputDecoration(labelText: 'Pseudo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Se connecter')),
          ]),
        ),
      ),
    );
  }
}