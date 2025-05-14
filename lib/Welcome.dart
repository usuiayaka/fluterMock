import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_application_1/HomePage.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/Cream_Lab.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // 自動再生
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 動画を表示
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
          ),
          // ボタンを動画の上に配置
          Positioned(
            bottom: 50,
            child: TextButton(
              child: Text("Welcome!! Push!!",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.5),
              ),
              onPressed: () {
                _controller.pause(); // 遷移前に動画を停止
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
