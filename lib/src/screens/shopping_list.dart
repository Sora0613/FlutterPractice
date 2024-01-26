import 'dart:convert';

import 'package:flutter/material.dart';

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

  void loadItemsFromJson() {
    // ダミーデータをJSON形式で表現
    const jsonString = '''
      [
        {"title": "アイテム1", "content": "メモ1"},
        {"title": "アイテム2", "content": "メモ2"},
        {"title": "アイテム3", "content": "メモ3"}
      ]
    ''';

    // JSONデータをList<ShoppingItem>に変換
    final jsonData = json.decode(jsonString) as List;
    shoppingItems = jsonData.map((item) => ShoppingItem.fromJson(item)).toList();
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
            // 削除ボタンの処理を追加
            _removeItem(index);
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
                _addItem(titleController.text, contentController.text);
                Navigator.of(context).pop();
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }

  void _addItem(String title, String content) {
    setState(() {
      shoppingItems.add(ShoppingItem(title: title, content: content));
    });
  }

  void _removeItem(int index) {
    setState(() {
      shoppingItems.removeAt(index);
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
}

class ShoppingItem {
  final String title;
  final String content;

  ShoppingItem({
    required this.title,
    required this.content,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      title: json['title'] as String,
      content: json['content'] as String,
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
