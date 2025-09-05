import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateChallengePage extends StatefulWidget {
  @override
  _CreateChallengePageState createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _createChallenge() async {
    String title = _titleController.text.trim();
    String desc = _descController.text.trim();
    if (title.isEmpty || desc.isEmpty) return;

    await FirebaseFirestore.instance.collection('challenges').add({
      'title': title,
      'description': desc,
      'participants': [],
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un challenge')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Titre')),
          TextField(controller: _descController, decoration: InputDecoration(labelText: 'Description')),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _createChallenge, child: Text('Créer')),
        ]),
      ),
    );
  }
}