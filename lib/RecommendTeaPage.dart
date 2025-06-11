import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/BottomNavigationBar.dart';
import 'package:flutter_application_1/HomePage.dart';
import 'package:flutter_application_1/Profile.dart';

class RecommendTeaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse by Worries'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Comming Soon\nもうすぐ公開予定！',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          } else if (index == 1) {
            // もう一度ProfilePageを開くときもUserから読み込みます
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));
          }
        },
      ),
    );
  }
}
