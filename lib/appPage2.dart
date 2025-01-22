import 'package:flutter/material.dart';
import 'package:flutter_application_1/appPage1.dart';

class appPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Myapp_SecondPege",
              style: TextStyle(
                color: Colors.white, // 文字色を白に設定
              ),
            ),
            backgroundColor: const Color(0xFF4682b4)),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 縦方向で中央に配置
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '次の画面へようこそ☆',
                  style: TextStyle(
                    color: const Color(0xFF4682b4),
                    fontSize: 20,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/c_img.jpg', // ほんとうは違う画像入れたかった...
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Center(
                  child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => appPage1()),
                  );
                },
                child: Text(
                  "最初のページに戻る？",
                  style: TextStyle(fontSize: 18),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF4682b4),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ))
            ]));
  }
}
