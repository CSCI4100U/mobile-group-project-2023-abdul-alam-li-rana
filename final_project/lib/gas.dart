import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';




Future<dynamic> getGasPrice() async {
  final String apiUrl = 'https://api.collectapi.com/gasPrice/canada';

  try {
    final http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'authorization': 'apikey 19OYwGO0oJUxUD4eL1tCjc:03CJJ2QQkWl3TjSR6Wlkii',
        'content-type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Successfully received response
      Map<String, dynamic> data = json.decode(response.body);
      print('Gas Price Data: $data');
      return data;
    } else {
      // Handle non-200 status codes
      print('Error Code: ${response.statusCode}');
      print('Error: ${response.reasonPhrase}');
      print('Response Body: ${response.body}');
    }
  } catch (error) {
    // Handle other errors, such as network errors
    print('Error: $error');
  }
}

