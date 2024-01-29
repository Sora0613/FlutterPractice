import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_practice/src/api.dart';
import 'package:http/http.dart' as http;

import '../auth_token.dart';

class ShareInfo extends StatefulWidget {
  const ShareInfo({Key? key}) : super(key: key);

  @override
  _ShareInfoState createState() => _ShareInfoState();
}

class _ShareInfoState extends State<ShareInfo> {
  List<Collaborator> collaborators = []; // 共有者のリスト

  @override
  void initState() {
    super.initState();
    loadCollaboratorsFromApi();
  }

  Future<void> loadCollaboratorsFromApi() async {
    const apiUrl = 'http://localhost:8080/api/collaborator';
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
          collaborators =
              jsonData.map((item) => Collaborator.fromJson(item)).toList();
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
        title: const Text('共有管理'),
      ),
      body: ListView.builder(
        itemCount: collaborators.length,
        itemBuilder: (context, index) {
          return _buildListItem(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ダイアログを表示して新しい共有者を追加
          _showAddCollaboratorDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListItem(int index) {
    final collaborator = collaborators[index];
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(collaborator.name),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _showDeleteConfirmationDialog(collaborator.id, collaborator.name);
          },
        ),
      ),
    );
  }

  void _showAddCollaboratorDialog() {
    // 新しい共有者を追加するためのダイアログを表示する処理をここに追加
  }

  void _removeCollaborator(int id, String token) {
    ApiService().deleteCollaborator(id, token).then((_) {
      setState(() {
        loadCollaboratorsFromApi();
        collaborators.removeWhere((element) => element.id == id);
      });
    });
  }

  void _showDeleteConfirmationDialog(int id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除の確認'),
          content: Text('「$name」を削除しますか？'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                TokenService.getToken().then((token) {
                  if (token != null) {
                    _removeCollaborator(id, token);
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('削除'),
            ),
          ],
        );
      },
    );
  }
}

class Collaborator {
  final int id;
  final String name;
  final String email;

  Collaborator({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Collaborator.fromJson(Map<String, dynamic> json) {
    return Collaborator(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
