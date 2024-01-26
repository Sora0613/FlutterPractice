import 'dart:convert';

import 'package:flutter/material.dart';

class InventoryList extends StatefulWidget {
  const InventoryList({Key? key}) : super(key: key);

  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  List<Item> items = []; // アイテムのリスト

  @override
  void initState() {
    super.initState();
    loadItemsFromJson();
  }

  void loadItemsFromJson() {
    // ダミーデータ
    const jsonString = '''
      [
        {"name": "商品1", "price": 1000, "quantity": 10, "jan": "123456789", "additionalInfo": "追加情報1"},
        {"name": "商品2", "price": 1500, "quantity": 5, "jan": "987654321", "additionalInfo": "追加情報2"},
        {"name": "商品3", "price": 2000, "quantity": 8, "jan": "456789123", "additionalInfo": "追加情報3"},
        {"name": "商品4", "price": 3000, "quantity": 3, "jan": "321654987", "additionalInfo": "追加情報4"},
        {"name": "商品5", "price": 5000, "quantity": 1, "jan": "789123456", "additionalInfo": "追加情報5"}
      ]
    ''';

    // JSONデータをList<Item>に変換
    final jsonData = json.decode(jsonString) as List;
    items = jsonData.map((item) => Item.fromJson(item)).toList();
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
            Text('JAN: ${items[index].jan}'),
            Text('追加ユーザ項目: ${items[index].additionalInfo}'),
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
  final String jan;
  final String additionalInfo;

  Item({
    required this.name,
    required this.price,
    required this.quantity,
    required this.jan,
    required this.additionalInfo,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      jan: json['jan'] as String,
      additionalInfo: json['additionalInfo'] as String,
    );
  }
}