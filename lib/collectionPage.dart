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

  void refreshTeas() {
    setState(() {
      _futureTeas = ApiService.fetchTeas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            centerTitle: true,
            floating: true,
            title: const Text(
              "Atyanaruのコレクション",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Registrationpage(),
                      ),
                    ).then((_) => refreshTeas());
                  },
                  child: const Text(
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
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('データがありません。')),
                );
              }

              final teas = snapshot.data!;
              return SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tea = teas[index];
                      return TeaGridTile(tea: tea, onUpdated: refreshTeas);
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
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));
          }
        },
      ),
    );
  }
}

class TeaGridTile extends StatelessWidget {
  const TeaGridTile({super.key, required this.tea, required this.onUpdated});

  final Tea tea;
  final VoidCallback onUpdated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Hero(
        tag: tea.image,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      tea.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 50),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                            Colors.grey,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Text(
                        tea.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final nameController = TextEditingController(text: tea.name);
    final descController = TextEditingController(text: tea.description);
    final aromaController = TextEditingController(text: tea.aroma);
    final tasteController = TextEditingController(text: tea.tasteType);
    final colorController = TextEditingController(text: tea.color);
    final imageController = TextEditingController(text: tea.image);

    bool isEditing = false;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageController.text,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 12),
                        isEditing
                            ? TextField(
                                controller: nameController,
                                decoration:
                                    const InputDecoration(labelText: "名前"),
                              )
                            : Text(
                                tea.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        isEditing
                            ? TextField(
                                controller: descController,
                                maxLines: null,
                                decoration:
                                    const InputDecoration(labelText: "説明"),
                              )
                            : Text(
                                tea.description,
                                textAlign: TextAlign.center,
                              ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: isEditing
                              ? [
                                  _editChipField("味タイプ", tasteController),
                                  _editChipField("香り", aromaController),
                                  _editChipField("色", colorController),
                                  _editChipField("画像URL", imageController),
                                ]
                              : [
                                  _buildInfoChip("味タイプ", tea.tasteType),
                                  _buildInfoChip("香り", tea.aroma),
                                  _buildInfoChip("色", tea.color),
                                ],
                        ),
                        const SizedBox(height: 16),
                        if (isEditing)
                          ElevatedButton(
                            onPressed: () async {
                              final updatedTea = Tea(
                                id: tea.id,
                                name: nameController.text,
                                image: imageController.text,
                                description: descController.text,
                                tasteType: tasteController.text,
                                aroma: aromaController.text,
                                color: colorController.text,
                              );

                              final success =
                                  await ApiService.updateTea(updatedTea);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(success ? "更新しました" : "更新に失敗しました"),
                                  ),
                                );
                                onUpdated(); // データ再取得
                              }
                            },
                            child: const Text("保存"),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(isEditing ? Icons.close : Icons.edit,
                            color: Colors.grey[800]),
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Chip(
      label: Text('$label: $value', style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _editChipField(String label, TextEditingController controller) {
    return SizedBox(
      width: 130,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
