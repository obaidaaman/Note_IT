import 'dart:convert';

import 'package:http/http.dart' as http;

class ServicePost {
  final title;
  final desc;

  ServicePost({required this.title, required this.desc});

  // post function process
  Future<String> servicesApi() async {
    final body = {
      "title": title,
      "description": desc,
      "is_completed": false};
    try {
      final url = "https://api.nstack.in/v1/todos";
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          body: jsonEncode(body),
          headers: {"Content-Type": 'application/json'});

      if (response.statusCode == 201) {
        print(response.statusCode);
        return "Creation Success";
      } else {
        print("Failed to upload data. Status code: ${response.statusCode}");
        return "Creation Failed";
      }
    } catch (error) {
      print("Error uploading data: $error");
      return "Error uploading";
    }
  }
}
