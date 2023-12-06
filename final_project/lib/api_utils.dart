import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'vehicle.dart';
import 'package:flutter/material.dart';

Future<String> getGasPrice() async {
  final String apiUrl = 'https://api.collectapi.com/gasPrice/canada';

  try {
    final http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'authorization': 'apikey 6GHS84gmlNuYbtc8yuyWIl:60AmY32MFxmkcUgUGXLDgq',
        'content-type': 'application/json',
      },
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> data = json.decode(response.body);
      String price = data['result']['gasoline'];
      print('Gas Price: $price');
      return price;
      throw Exception('Failed to fetch gas price:');

    } else {

      print('Error Code: ${response.statusCode}');
      print('Error: ${response.reasonPhrase}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to fetch gas price: ${response.reasonPhrase}');

    }
  } catch (error) {

    print('Error: $error');
    return "None"; // or handle the error accordingly
  }
}




Future<String> getAIHelp(String textinput, Vehicle? vehicle) async {
  final String apiUrl = 'https://api.collectapi.com/gasPrice/canada';

  try {
    final http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'authorization': 'apikey 6GHS84gmlNuYbtc8yuyWIl:60AmY32MFxmkcUgUGXLDgq',
        'content-type': 'application/json',
      },
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> data = json.decode(response.body);
      String price = data['result']['gasoline'];
      print('Gas Price: $price');
      return price;
      throw Exception('Failed to fetch gas price:');

    } else {

      print('Error Code: ${response.statusCode}');
      print('Error: ${response.reasonPhrase}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to fetch gas price: ${response.reasonPhrase}');

    }
  } catch (error) {

    print('Error: $error');
    return "False";
  }
}
