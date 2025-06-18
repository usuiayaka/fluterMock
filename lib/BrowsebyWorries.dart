import 'package:flutter/material.dart';
import '../models/tea.dart';
import '../services/api_service.dart';
import 'package:flutter_application_1/components/BottomNavigationBar.dart';
import 'package:flutter_application_1/Profile.dart';
import 'package:flutter_application_1/HomePage.dart';

class BrowseByWorriesPage extends StatefulWidget {
  const BrowseByWorriesPage({super.key});

  @override
  State<BrowseByWorriesPage> createState() => _BrowseByWorriesPageState();
}

class _BrowseByWorriesPageState extends State<BrowseByWorriesPage> {
  late Future<List<Tea>> _futureTeas;

  // データに基づいてカテゴリを拡充
  final Map<String, List<String>> worryCategories = {
    'リラックスしたい': [
      'カモミール',
      'ペパーミント',
      'ラベンダー',
      'ジャスミン',
      'レモンバーム',
      'ローズペタル',
      'バレリアン'
    ],
    '美容に良い': ['ローズヒップ', 'マロウブルー', 'ローズペタル'],
    '体を温めたい': ['ジンジャー', 'ネトル', 'シナモン'],
    '免疫を高めたい': ['エルダーフラワー', 'タイム'],
    '集中力を高めたい': ['ローズマリー'],
    '消化を助けたい': ['フェンネル', 'ジンジャー', 'アニスヒソップ', 'チコリー', 'カルダモン', 'セージ', 'レモンバーム'],
    '気分転換したい': ['バタフライピー', 'ペパーミント', 'ローズマリー'],
    '睡眠改善したい': ['バレリアン', 'カモミール'],
    '喉のケアをしたい': ['マロウブルー'],
    '血圧を安定させたい': ['ハイビスカス', 'ホーソン'],
    '抗炎症・抗菌作用が欲しい': ['タイム', 'セージ', 'シナモン', 'アニスヒソップ'],
    'ホルモンバランス調整・デトックス': ['レッドクローバー'],
    '尿路ケアをしたい': ['レッドベリー'],
    '心臓機能改善': ['ホーソン'],
  };

  // カテゴリごとのアイコンマップ
  final Map<String, IconData> worryIcons = {
    'リラックスしたい': Icons.spa,
    '美容に良い': Icons.face_retouching_natural,
    '体を温めたい': Icons.local_fire_department,
    '免疫を高めたい': Icons.shield,
    '集中力を高めたい': Icons.lightbulb,
    '消化を助けたい': Icons.restaurant,
    '気分転換したい': Icons.refresh,
    '睡眠改善したい': Icons.bedtime,
    '喉のケアをしたい': Icons.healing,
    '血圧を安定させたい': Icons.favorite,
    '抗炎症・抗菌作用が欲しい': Icons.medical_services,
    'ホルモンバランス調整・デトックス': Icons.wb_sunny,
    '尿路ケアをしたい': Icons.water_drop,
    '心臓機能改善': Icons.favorite_border,
    'その他': Icons.local_florist,
  };

  @override
  void initState() {
    super.initState();
    _futureTeas = ApiService.fetchTeas();
  }

  Map<String, List<Tea>> _groupByWorries(List<Tea> teas) {
    final Map<String, List<Tea>> map = {
      for (var key in worryCategories.keys) key: [],
      'その他': [],
    };

    for (var tea in teas) {
      bool assigned = false;
      for (var category in worryCategories.entries) {
        if (category.value.contains(tea.name)) {
          map[category.key]!.add(tea);
          assigned = true;
          break;
        }
      }
      if (!assigned) {
        map['その他']!.add(tea);
      }
    }
    return map;
  }

  void _showTeaDetailDialog(BuildContext context, Tea tea) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      tea.image,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tea.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tea.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('閉じる'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeaTile(BuildContext context, Tea tea) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          tea.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        ),
      ),
      title: Text(tea.name),
      subtitle: Text(
        tea.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _showTeaDetailDialog(context, tea),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('悩み別おすすめハーブティー'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Tea>>(
        future: _futureTeas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('データがありません。'));
          }

          final grouped = _groupByWorries(snapshot.data!);

          return ListView(
            padding: const EdgeInsets.all(8),
            children: grouped.entries.map((entry) {
              if (entry.value.isEmpty) return const SizedBox.shrink();

              return ExpansionTile(
                leading: Icon(worryIcons[entry.key] ?? Icons.local_florist,
                    color: Colors.blueAccent),
                title: Text(
                  entry.key,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                children: entry.value
                    .map((tea) => _buildTeaTile(context, tea))
                    .toList(),
              );
            }).toList(),
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
}
