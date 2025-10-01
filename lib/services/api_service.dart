import 'dart:convert';
import 'package:connect/Utils/app_strings.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static Future<Map<String, dynamic>?> login(String name) async {
    final url = Uri.parse("${Urls.baseUrl}/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name}),
    );

    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // user object
    } else {
      return null;
    }
  }

  static Future<List<dynamic>> getUsers() async {
    final url = Uri.parse("${Urls.baseUrl}/users");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> getMessages(String user1, String user2) async {
    final url = Uri.parse("${Urls.baseUrl}/api/messages/$user1/$user2");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> sendMessage(
      String sender, String receiver, String text) async {
    final url = Uri.parse("${Urls.baseUrl}/api/messages");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "sender": sender,
        "receiver": receiver,
        "text": text,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }


}
