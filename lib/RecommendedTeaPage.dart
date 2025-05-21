import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomePage.dart';

class Tea {
  final int id;
  final String name;
  final String image;
  final String description;
  const Tea({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });
}

class RecommendedTeaPage extends StatelessWidget {
  const RecommendedTeaPage({super.key});

  final List<Tea> teas = const [
    Tea(
      id: 1,
      name: "アールグレイ",
      image: "assets/images/アールグレイ.jpg",
      description: "ベルガモットの香りが特徴の紅茶",
    ),
    Tea(
      id: 2,
      name: "ダージリン",
      image: "assets/images/ダージリン.jpg",
      description: "紅茶のシャンパンと呼ばれる上品な香り",
    ),
    Tea(
      id: 3,
      name: "アッサム",
      image: "assets/images/アッサム.jpg",
      description: "濃厚でミルクティーに最適",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scrollbar(
            child: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            "Your collections",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          floating: true,
        ),
        SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tea = teas[index];
                  return TeaListTile(tea: tea);
                },
                childCount: teas.length,
              ),
            )),
      ],
    )));
  }
}

class TeaListTile extends StatelessWidget {
  const TeaListTile({super.key, required this.tea});

  final Tea tea;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _showDetails(context),
        child: Row(
          children: [
            Image.asset(
              tea.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                tea.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "tea_detail",
      barrierDismissible: true,
      pageBuilder: (_, __, ___) => Container(),
      transitionBuilder: (ctx, a1, a2, child) {
        final scale = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: scale,
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    tea.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tea.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
