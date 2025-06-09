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
              ]),
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
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tea = teas[index];
                      return TeaListTile(tea: tea);
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
            Image.network(
              tea.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, StackTrace) => Icon(Icons.image),
            ),
            const SizedBox(width: 16),
            Expanded(
                child: Text(
              tea.name,
              style: Theme.of(context).textTheme.titleLarge,
            ))
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
        pageBuilder: (
          _,
          __,
          ___,
        ) =>
            Container(),
        transitionBuilder: (ctx, a1, a2, child) {
          final scale = Curves.easeInOut.transform(a1.value);
          return Transform.scale(
            scale: scale,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
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
                    Text(
                      tea.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
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
        });
  }
}
