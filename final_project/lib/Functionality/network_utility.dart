import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NetworkUtility {
  static Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async{
    try{
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200){
        print("hello works?");
        return response.body;
      }
    } catch (e){
      print(e.toString());
    }
    return null;
  }
}