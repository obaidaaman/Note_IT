import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/ItemsModel.dart';
class UserGetApi{
  static Future<List<Items>?> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List<dynamic>;

      final transformed = result.map((e){

        return Items(
            sId: e['_id'],
            title: e['title'],
            createdAt: e['created_at'],
            description: e['description'],
            isCompleted: e['is_completed'],
            updatedAt: e['uploaded_at']
        );
      }).toList();

      return transformed;
    } else {

      return null;
    }
  }

}