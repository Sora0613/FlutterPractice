import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

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

    try {
      final response = await http.get(Uri.parse(apiUrl));

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
            Text('価格: ${items[index].price}'),
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
                // 数量増加ボタンの処理を追加
              },
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                // 数量減少ボタンの処理を追加
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // 編集ボタンの処理を追加
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // 削除ボタンの処理を追加
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final int price;
  final int quantity;
  final int JAN;
  final String user_name;

  Item({
    required this.name,
    required this.price,
    required this.quantity,
    required this.JAN,
    required this.user_name,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      JAN: json['JAN'] as int,
      user_name: json['user_name'] as String,
    );
  }
}
