import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareInfo extends StatefulWidget {
  const ShareInfo({Key? key}) : super(key: key);

  @override
  _ShareInfoState createState() => _ShareInfoState();
}

class _ShareInfoState extends State<ShareInfo> {
  List<String> names = ['John Doe', 'Jane Doe', 'Alice', 'Bob']; // ダミーデータ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('共有管理'),
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInviteOptions();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, index) {
        return _buildListItem(index);
      },
    );
  }

  Widget _buildListItem(int index) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(names[index]),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _removeItem(index);
          },
        ),
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      names.removeAt(index);
    });
  }

  void _showInviteOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('リンクを生成する'),
              onTap: () {
                // リンクを生成する処理
                _generateLink();
                Navigator.pop(context); // モーダルを閉じる
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('emailで招待する'),
              onTap: () {
                // 画面遷移してemail招待画面へ
                Navigator.pop(context); // モーダルを閉じる
                _navigateToEmailInvitationScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void _generateLink() {
    // 適当なURLを生成しクリップボードにコピー
    const link = 'https://example.com/invitation';
    Clipboard.setData(ClipboardData(text: link));

    // 通知を表示
    _showNotification('コピーしました: $link');
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void _navigateToEmailInvitationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailInvitationScreen(),
      ),
    );
  }
}

class EmailInvitationScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('emailで招待'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300.0, // テキストボックスの幅を設定
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Emailアドレス'),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // 招待ボタンを押した時の処理
                _sendEmailInvitation();
                Navigator.pop(context);
              },
              child: const Text('招待'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmailInvitation() {
    // TODO: emailで招待する処理をここに記述
    // 例: メールを送信するライブラリを使用して、_emailController.text に入力されたメールアドレスに招待メールを送信する
    // 送信後に通知を表示するなどの処理も追加すると良い

  }
}
