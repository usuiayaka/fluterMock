import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/tea.dart';
import '../services/api_service.dart';
import 'package:flutter_application_1/components/BottomNavigationBar.dart';
import 'package:flutter_application_1/Profile.dart';
import 'package:flutter_application_1/RegistrationPage.dart';
import 'package:flutter_application_1/HomePage.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  late Future<List<Tea>> _futureTeas;

  @override
  void initState() {
    super.initState();
    _futureTeas = ApiService.fetchTeas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            centerTitle: true,
            floating: true,
            title: Text(
              "Your Collections",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    // 登録用ページへ
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Registrationpage(),
                        ));
                  },
                  child: Text(
                    '登録する',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
          FutureBuilder<List<Tea>>(
            future: _futureTeas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('データがありません。')),
                );
              }

              final teas = snapshot.data!;
              return SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // ２列にする
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1, // 正方形にする
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tea = teas[index];
                      return TeaGridTile(tea: tea);
                    },
                    childCount: teas.length,
                  ),
                ),
              );
            },
          )
        ]),
      ),
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
}

class TeaGridTile extends StatelessWidget {
  const TeaGridTile({super.key, required this.tea});

  final Tea tea;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // 角丸＋画像切り取り
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showDetails(context),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                tea.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, StackTrace) =>
                    Icon(Icons.image, size: 50),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                color: Colors.black.withOpacity(0.4), // 半透明の背景
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  tea.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    tea.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, StackTrace) =>
                        Icon(Icons.image),
                  ),
                  const SizedBox(height: 12),
                  Text(tea.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 10),
                  Text('味タイプ:${tea.tasteType}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text('香り:${tea.aroma}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text('色:${tea.color}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
