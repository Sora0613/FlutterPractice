import 'package:flutter/material.dart';
import 'package:flutter_practice/src/api.dart'; // API関連の処理を記述したファイルをインポート
import 'package:flutter_practice/src/auth_token.dart';
import 'Auth/LoginPage.dart'; // ログイン画面のファイルをインポート
import 'screens/account.dart';
import 'screens/share_info.dart';
import 'screens/inventory_list.dart';
import 'screens/shopping_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ダミーデータ。実際には認証状態を取得する必要があります。
    // tokenを取得する
    final token = TokenService.getToken();
    if (token != null) {
      bool isLoggedIn = true;
    }
    bool isLoggedIn = false;


    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? const MyStatefulWidget() : LoginPage(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const List<Widget> _screens = [
    InventoryList(),
    ShoppingList(),
    ShareInfo(),
    AccountScreen()
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '在庫一覧'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: '買い物リスト'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '共有管理'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
