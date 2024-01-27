import 'package:flutter/material.dart';

import 'RegisterPage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'ユーザー名'),
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'パスワード'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // ログインボタンが押されたときの処理
                // TODO: ログイン処理を追加
                // ログインに成功したらホーム画面に遷移
              },
              child: const Text('ログイン'),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                // 新規登録画面に遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: const Text('新規登録'),
            ),
          ],
        ),
      ),
    );
  }
}