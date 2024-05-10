import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> postData(String url, Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode(data),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    // Process the successful response
  } else {
    // Handle error
  }
}
