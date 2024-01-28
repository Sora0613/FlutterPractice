import 'package:flutter/material.dart';
import 'package:flutter_practice/src/api.dart';

import '../auth_token.dart';
import '../nav.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'メールアドレス'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'パスワード'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  // ログインボタンが押された時の処理
                  final token = await ApiService().login(emailController.text, passwordController.text);
                  if (token != null) {
                    await TokenService.saveToken(token);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyStatefulWidget()),
                    );
                  } else {
                    // ログイン失敗時の処理を追加
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('ログインエラー'),
                        content: const Text('メールアドレスまたはパスワードが間違っています。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('ログイン'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
