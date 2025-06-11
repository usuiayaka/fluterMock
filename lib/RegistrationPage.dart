import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/components/BottomNavigationBar.dart';
import 'package:flutter_application_1/Profile.dart';
import 'package:flutter_application_1/HomePage.dart';

class Registrationpage extends StatefulWidget {
  const Registrationpage({super.key});

  @override
  State<Registrationpage> createState() => _RegistrationpageState();
}

class _RegistrationpageState extends State<Registrationpage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tasteTypeController = TextEditingController();
  final TextEditingController _aromaController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  XFile? _pickedXFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedXFile = pickedFile;
      });
    }
  }

  Future<String?> uploadImageToFirebase(XFile imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child('tea_image/$fileName.jpg');

      //ファイルをアップロードする
      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        await storageRef.putData(
            bytes, SettableMetadata(contentType: 'image/jpeg'));
      } else {
        final file = File(imageFile.path);
        await storageRef.putFile(file);
      }
      //ダウンロード
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('画像のアップロード失敗:$e');
      return null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tasteTypeController.dispose();
    _aromaController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Widget _buildImage() {
    if (_pickedXFile == null) {
      return Container(
        width: double.infinity,
        height: 100,
        color: Colors.grey[300],
        child: const Icon(
          Icons.add_a_photo,
          size: 50,
          color: Colors.grey,
        ),
      );
    } else {
      if (kIsWeb) {
        // Webの場合はbytesを読み込んでImage.memoryで表示
        return FutureBuilder<Uint8List>(
            future: _pickedXFile!.readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                );
              } else {
                return Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
            });
      } else {
        // モバイルなどはFileを使う
        return Image.file(
          // ignore: avoid_web_libraries_in_flutter
          File(_pickedXFile!.path),
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登録'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //画像ピッカー
                const Text('画像を選択'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: _buildImage(),
                ),
                const SizedBox(height: 16),

                //名前
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '名前',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '名前を入力してください';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                //説明
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: '説明',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '説明を入力してください';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 味のタイプ
                TextFormField(
                  controller: _tasteTypeController,
                  decoration: const InputDecoration(
                    labelText: '味のタイプ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '説明を入力してください';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 香り
                TextFormField(
                  controller: _aromaController,
                  decoration: const InputDecoration(
                    labelText: '香り',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '説明を入力してください';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 色
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    labelText: '色',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '説明を入力してください';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_pickedXFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('画像を選択してください')),
                        );
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        // Firebaseに画像アップロード
                        final imageUrl =
                            await uploadImageToFirebase(_pickedXFile!);
                        if (imageUrl == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('画像アップロードに失敗しました')),
                          );
                          return;
                        }

                        // 他のデータ取得
                        final name = _nameController.text;
                        final description = _descriptionController.text;
                        final tasteType = _tasteTypeController.text;
                        final aroma = _aromaController.text;
                        final color = _colorController.text;

                        // APIへ登録
                        final success = await ApiService.postTea(
                          name: name,
                          image: imageUrl, // ← URLを渡す！
                          description: description,
                          tasteType: tasteType,
                          aroma: aroma,
                          color: color,
                        );

                        if (success) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('登録成功'),
                              content: const Text('新しいハーブティーを登録しました。'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                )
                              ],
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('登録に失敗しました。')),
                          );
                        }
                      }
                    },
                    child: const Text('登録する'),
                  ),
                ),
              ],
            ),
          ),
        ),
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
