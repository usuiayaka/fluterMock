import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar(
      {required this.currentIndex, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.blueAccent,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "ホーム"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "プロフィール"),
      ],
    );
  }
}
