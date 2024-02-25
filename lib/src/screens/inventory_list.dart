import 'dart:convert';
import 'package:flutter_practice/src/api.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../auth_token.dart';

class InventoryList extends StatefulWidget {
  const InventoryList({Key? key}) : super(key: key);

  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  List<Item> items = []; // 在庫アイテムのリスト

  @override
  void initState() {
    super.initState();
    loadItemsFromJson();
  }

  Future<void> loadItemsFromJson() async {
    const String apiUrl = 'http://localhost:8080/api/inventory';
    final token = await TokenService.getToken();

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // トークンをここに追加する
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        setState(() {
          items = jsonData.map((item) => Item.fromJson(item)).toList();
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('在庫一覧'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // 在庫登録画面へ遷移する処理を追加
                },
                child: const Text('在庫登録'),
              ),
              ElevatedButton(
                onPressed: () {
                  // JAN登録画面へ遷移する処理を追加
                },
                child: const Text('JAN登録'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildListItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(int index) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('名前: ${items[index].name}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 価格がnullの場合は「未設定」と表示する
            Text('価格: ${items[index].price ?? '未設定'}'),
            Text('数量: ${items[index].quantity}'),
            Text('JAN: ${items[index].JAN}'),
            Text('追加ユーザ項目: ${items[index].user_name}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // get item id and token
                int id = items[index].id;
                TokenService.getToken().then((token) {
                  if (token != null) {
                    _addQuantity(id, token);
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                int id = items[index].id;
                TokenService.getToken().then((token) {
                  if (token != null) {
                    _reduceQuantity(id, token);
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // 編集ボタンの処理を追加
                //画面遷移（遷移後に現在のリストの値を取得してそれをテキストボックスにすでに入力された状態にしたい）
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                int id = items[index].id;
                TokenService.getToken().then((token) {
                  if (token != null) {
                    _showDeleteConfirmationDialog(id, token);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addQuantity(int id, String token) {
    ApiService().addQuantity(id, token).then((_) {
      // API呼び出しが成功したらリストからアイテムを削除してUIを更新
      setState(() {
        loadItemsFromJson();
      });
    }).catchError((error) {
      // エラーハンドリング
      print('Error occurred while adding item: $error');
    });
  }

  void _reduceQuantity(int id, String token) {
    ApiService().reduceQuantity(id, token).then((_) {
      setState(() {
        loadItemsFromJson();
      });
    }).catchError((error) {
      print('Error occurred while reducing item: $error');
    });
  }

  void _deleteInventoryItem(int id, String token) {
    ApiService().deleteInventoryItem(id, token).then((_) {
      setState(() {
        // remove item from the list
        items.removeWhere((item) => item.id == id);
      });
    }).catchError((error) {
      print('Error occurred while deleting item: $error');
    });
  }

  void _showDeleteConfirmationDialog(int id, String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('削除の確認'),
          content: Text('本当に削除しますか？'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteInventoryItem(id, token);
              },
              child: Text('削除'),
            ),
          ],
        );
      },
    );
  }
}

class Item {
  final int id;
  final String name;
  final int? price; // Nullable int
  final int quantity;
  final int JAN;
  final String user_name;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.JAN,
    required this.user_name,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int?, // Nullable int
      quantity: json['quantity'] as int,
      JAN: json['JAN'] as int,
      user_name: json['user_name'] as String,
    );
  }
}

