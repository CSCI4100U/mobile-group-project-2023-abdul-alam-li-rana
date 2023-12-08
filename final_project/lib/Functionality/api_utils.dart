import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:final_project/Vehicles/vehicle.dart';
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




Future<String> getAIHelp(String textInput, Vehicle? vehicle) async {
  print("trying to send request");
  try {
    String apiKey = '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';
    
    String endpoint = 'https://api.openai.com/v1/chat/completions'; // This endpoint might change, check OpenAI documentation

    Map<String, dynamic> promptData = {
      "model":"gpt-3.5-turbo",
       "messages":[
        {
        "role": "system",
        "content": "You are a Vehicle Helper Asistant AI, skilled at leveraging all your information to help on all sorts of vehicles and their problems. When a user asks you about their vehicle, give a list of what the problem could be each with a solution, and then give what you think it most likely is"
      },
        {
      'role':"user",
      'content': 'ChatGPT, I need help on this vehicle. Attributes: ${vehicle?.toMap()}. Problem: $textInput',
        }
        
       ]
    };

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(promptData),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print('$data');
      print("does anything return?");
      
      if (data['choices'] != null && data['choices'].isNotEmpty) {
        String generatedText = data['choices'][0]['message']['content'];
        
        if (generatedText != null) {
          print(generatedText);
          return generatedText;
        } else {
          print('Error: Content is null.');
          return "False";
        }
      }
      return "False";  
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('HTTP Error: ${response.body}');

      return 'False';
    }
  } catch (error) {
    print('Error: $error');
    return 'False';
  }
}
