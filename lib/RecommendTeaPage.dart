import 'package:flutter/material.dart';
import '../models/tea.dart';
import '../services/api_service.dart';
import 'package:flutter_application_1/components/BottomNavigationBar.dart';
import 'package:flutter_application_1/Profile.dart';
import 'package:flutter_application_1/HomePage.dart';

class RecommendTeaPage extends StatefulWidget {
  const RecommendTeaPage({super.key});

  @override
  State<RecommendTeaPage> createState() => _RecommendTeaPageState();
}

class _RecommendTeaPageState extends State<RecommendTeaPage> {
  late Future<List<Tea>> _futureTeas;

  @override
  void initState() {
    super.initState();
    _futureTeas = ApiService.fetchTeas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('おすすめハーブティー'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Tea>>(
        future: _futureTeas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('おすすめデータがありません。'));
          }

          final teas = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 16, // 上下の間隔を広めに
              childAspectRatio: 0.6, // 高さを少し増やす
              children: teas.map((tea) => _buildTeaCard(context, tea)).toList(),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
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

  Widget _buildTeaCard(BuildContext context, Tea tea) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4), // カードの上下マージン追加
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 画像部分
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              tea.image,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          // テキスト部分
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tea.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tea.description,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(), // 下にタグを寄せる
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      _buildTag(tea.tasteType),
                      _buildTag(tea.aroma),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}
