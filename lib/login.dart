import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_application_1/HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _passController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final pass = _passController.text.trim();

    if (name.isEmpty || pass.isEmpty) {
      setState(() {
        _errorMessage = '名前とパスワードを入力してください';
        _isLoading = false;
      });
      return;
    }

    try {
      final success = await ApiService.postUser(name: name, pass: pass);
      if (success) {
        // ログイン成功。必要ならホーム画面などへ遷移
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ログイン成功！')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        setState(() {
          _errorMessage = 'ログインに失敗しました。名前かパスワードが違います。';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'エラーが発生しました。もう一度試してください。';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ログイン')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '名前'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passController,
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('ログイン'),
                  ),
            if (_errorMessage != null) ...[
              SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
