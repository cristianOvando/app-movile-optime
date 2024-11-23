import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ContactService {
  static Future<Map<String, dynamic>?> createContact(
    String email,
    String name,
    String lastName,
    String phone,
  ) async {
    final url = Uri.parse('${Constants.baseUrl}/contacts');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'name': name,
        'last_name': lastName,
        'phone': phone,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); 
    } else {
      return null; 
    }
  }
}
