import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_practice/src/api.dart';

import '../auth_token.dart';
import 'package:http/http.dart' as http;


class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<ShoppingItem> shoppingItems = []; // 買い物アイテムのリスト

  @override
  void initState() {
    super.initState();
    loadItemsFromJson();
  }

  Future<void> loadItemsFromJson() async {
    // ダミーデータをJSON形式で表現
    const String apiUrl = 'http://localhost:8080/api/shoppinglist';
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
          shoppingItems = jsonData.map((item) => ShoppingItem.fromJson(item)).toList();
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
        title: const Text('買い物リスト'),
      ),
      body: ListView.builder(
        itemCount: shoppingItems.length,
        itemBuilder: (context, index) {
          return _buildListItem(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // モーダルを表示する処理を追加
          _showAddItemDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('タイトル: ${shoppingItems[index].title}'),
        subtitle: Text('内容: ${shoppingItems[index].content}'),
        onTap: () {
          // リストをタップした際に詳細画面に遷移
          _navigateToDetailScreen(context, shoppingItems[index]);
        },
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            //削除ボタンを押した時に削除APIを走らせる。
            int id = shoppingItems[index].id;
            TokenService.getToken().then((token) {
              if (token != null) {
                _removeItem(id, token);
              }
            });
          },
        ),
      ),
    );
  }

  Future<void> _showAddItemDialog() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('アイテムを追加'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'タイトル'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: '内容'),
                maxLines: null, // 改行を可能にする
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                // 追加ボタンを押した時の処理
                TokenService.getToken().then((token) {
                  if (token != null) {
                    _addItem(titleController.text, contentController.text, token);
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }

  void _removeItem(int id, String token) {
    ApiService().deleteItem(id, token).then((_) {
      // API呼び出しが成功したらリストからアイテムを削除してUIを更新
      setState(() {
        shoppingItems.removeWhere((item) => item.id == id);
      });
    }).catchError((error) {
      // エラーハンドリング
      print('Error occurred while deleting item: $error');
    });
  }


  void _navigateToDetailScreen(BuildContext context, ShoppingItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(item: item),
      ),
    );
  }

  void _addItem(String text, String text2, token) {
    ApiService().addItem(text, text2, token).then((_) {
      setState(() {
        // add item to the list.
        loadItemsFromJson();
      });
    }).catchError((error) {
      // エラーハンドリング
      print('Error occurred while adding item: $error');
    });
  }
}

class ShoppingItem {
  final String title;
  final String content;
  final int id;

  ShoppingItem({
    required this.title,
    required this.content,
    required this.id,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      title: json['title'] as String,
      content: json['content'] as String,
      id: json['id'] as int,
    );
  }
}

class DetailScreen extends StatelessWidget {
  final ShoppingItem item;

  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'タイトル: ${item.title}',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              '内容: ${item.content}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
