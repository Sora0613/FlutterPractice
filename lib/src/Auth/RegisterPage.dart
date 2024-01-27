import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
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
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: '確認用パスワード'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // 新規登録ボタンが押されたときの処理
                // TODO: 新規登録処理を追加
              },
              child: const Text('新規登録'),
            ),
          ],
        ),
      ),
    );
  }
}