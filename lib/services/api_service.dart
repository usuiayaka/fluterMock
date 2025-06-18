import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tea.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  // 一覧の取得
  static Future<List<Tea>> fetchTeas() async {
    final response = await http.get(Uri.parse('$baseUrl/teas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Tea.fromJson(json)).toList();
    } else {
      throw Exception('お茶の一覧取得に失敗しました');
    }
  }

  // 登録（POST）
  static Future<bool> postTea({
    required String name,
    required String image,
    required String description,
    required String tasteType,
    required String aroma,
    required String color,
  }) async {
    final url = Uri.parse('$baseUrl/teas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'image': image,
        'description': description,
        'tasteType': tasteType,
        'aroma': aroma,
        'color': color,
      }),
    );
    print('Status Code: ${response.statusCode}');
    print('Response Body:${response.body}');

    return response.statusCode == 201;
  }

  // ログイン検証（POST）
  static Future<bool> postUser({
    required String name,
    required String pass,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'password': pass,
      }),
    );
    print('Status Code: ${response.statusCode}');
    print('Response Body:${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      User.setUserInfo(decoded['name'], decoded['img'] ?? '');
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateTea(Tea tea) async {
    final url = Uri.parse('$baseUrl/teas/${tea.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': tea.name,
        'image': tea.image,
        'description': tea.description,
        'tasteType': tea.tasteType,
        'aroma': tea.aroma,
        'color': tea.color,
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return response.statusCode == 200;
  }
}
