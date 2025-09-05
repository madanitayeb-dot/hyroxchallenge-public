import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String avatarName;
  AvatarWidget({required this.avatarName});

  static List<String> avatarList = [
    'avatar1.png',
    'avatar2.png',
    'avatar3.png',
    'avatar4.png',
    'avatar5.png',
  ];

  static String randomAvatar() {
    avatarList.shuffle();
    return avatarList.first;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage('assets/avatars/$avatarName'),
    );
  }
}