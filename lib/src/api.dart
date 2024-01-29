import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String?> login(String email, String password) async {
    final String apiUrl = 'http://localhost:8080/api/authenticate';
    try {
      // リクエストボディを作成
      Map<String, String> body = {
        'email': email,
        'password': password,
      };

      // リクエストヘッダーを作成
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      // POSTリクエストを送信してレスポンスを取得
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      // レスポンスのステータスコードが200 OKであることを確認
      if (response.statusCode == 200) {
        // レスポンスボディを解析し、トークンを取得
        final Map<String, dynamic> data = json.decode(response.body);
        String? token = data['api_token'];
        return token;
      } else {
        // ログインに失敗した場合はnullを返す
        return null;
      }
    } catch (e) {
      // エラーが発生した場合はnullを返す
      return null;
    }
  }

  //shopping list
  Future<void> deleteItem(id, token) async {
    final String apiUrl = 'http://localhost:8080/api/shoppinglist/delete/$id';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Item deleted successfully');
      } else {
        print('Failed to delete item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addItem(title, content, token) async {
    final String apiUrl = 'http://localhost:8080/api/shoppinglist/store';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'title': title,
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        print('List created successfully');
        print(response.body);
      } else {
        print('Failed to create list: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //inventory list
  Future<void> addQuantity(id, token) async {
    final String apiUrl = 'http://localhost:8080/api/inventory/addQuantity/$id';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Item added successfully');
      } else {
        print('Failed to add item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> reduceQuantity(id, token) async {
    final String apiUrl = 'http://localhost:8080/api/inventory/reduceQuantity/$id';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Item reduced successfully');
      } else {
        print('Failed to reduce item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteInventoryItem(id, token) async {
    final String apiUrl = 'http://localhost:8080/api/inventory/delete/$id';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Item deleted successfully');
      } else {
        print('Failed to delete inventory item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //collaborator list
  Future<void> deleteCollaborator(id, token) async {
    final String apiUrl = 'http://localhost:8080/api/collaborator/delete/$id';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Collaborator deleted successfully');
      } else {
        print('Failed to delete collaborator: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
