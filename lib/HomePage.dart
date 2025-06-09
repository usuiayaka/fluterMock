import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/BottomNavigationBar.dart';
import 'package:flutter_application_1/collectionPage.dart';
import 'package:flutter_application_1/Profile.dart';
import 'package:flutter_application_1/RecommendTeaPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0;
  int currentPageIndex = 0;

  final List<Map<String, String>> items = [
    {
      "image": "assets/images/a_herbtea.png",
      "text": "Your Collection\nあなたのコレクション"
    },
    {
      "image": "assets/images/a_colorful_herbtea.png",
      "text": "Recommended Herb Tea\nおすすめのハーブティー"
    },
    {
      "image": "assets/images/a_bule_herbtea.png",
      "text": "Browse by Worries\n悩み別で探す"
    },
  ];

  final List<String> Navtext = [
    "Your\nCollection",
    "Recommended\nHerbTea",
    "Browse by\nWorries"
  ];

  void selectCategory(int index) {
    setState(() {
      selectedIndex = index;
    });

    _scrollController.animateTo(
      index * 270.0,
      duration: Duration(milliseconds: 500), // 修正済み
      curve: Curves.easeInOut,
    );
  }

  void onBottomNavTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildHomePageContent(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HomePage()));
          } else if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProfilePage(
                        nickname: "Atyaneru",
                        profileImageUrl: "assets/images/hokori.jpg")));
          }
        },
      ),
    );
  }

  Widget buildHomePageContent() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFFEEEEEE),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/images/hokori.jpg"),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello! Ready for a great day?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                Text("Atyanaru",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Discover your best flavor.",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
              Text(
                  "How are you feeling today?\nAre you experiencing any discomfort or health concerns?",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),

              SizedBox(height: 15),

              // **カテゴリー選択部分**
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    items.length,
                    (index) => GestureDetector(
                      onTap: () => selectCategory(index),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, right: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              Navtext[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: selectedIndex == index
                                    ? Colors.blueAccent
                                    : Colors.black,
                              ),
                            ),
                            // **選択時のみ丸い下線を表示**
                            AnimatedContainer(
                              duration:
                                  Duration(milliseconds: 300), // アニメーション効果
                              height: 8, // 丸のサイズ
                              width: selectedIndex == index ? 8 : 0, // 選択時のみ表示
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle, // **円形に変更**
                              ),
                              margin: EdgeInsets.only(top: 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // **横スクロールのカード**
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(
                  children: List.generate(
                    items.length,
                    (index) => buildImageCard(
                        items[index]["image"]!, items[index]["text"]!, index),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageCard(String imagePath, String text, int index) {
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: GestureDetector(
        onTap: () {
          if (index == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CollectionPage()));
          }
          if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => RecommendTeaPage()));
          }
          if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => RecommendTeaPage()));
          }
        },
        child: Stack(
          children: [
            Container(
              height: 350,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage(imagePath), fit: BoxFit.cover),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 15,
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.5))
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
