import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:flutter_application_1/components/BottomNavigationBar.dart';
import 'package:flutter_application_1/HomePage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nickname = User.name ?? '名無し';
    final profileImageUrl =
        User.img ?? 'https://example.com/default_profile.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('プロフィール'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(profileImageUrl),
            ),
            const SizedBox(height: 20),
            Text(
              nickname,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HomePage()));
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
