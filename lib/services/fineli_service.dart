import 'dart:convert';

import 'package:http/http.dart' as http;

class FineliService {

  static Future<List<Map<String, dynamic>>?> getFoodItem(String item) async {
    final String url = "https://fineli.fi/fineli/api/v1/foods?q=$item";
    print(url);
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // print(response.body);
        // print(jsonDecode(response.body).runtimeType);
        final data = (jsonDecode(response.body) as List).map((e) => e as Map<String, dynamic>).toList();
        return data;
      } else {
        print("Error ${response.statusCode}");
        return null;
      }
    } catch (e, stacktrace) {
      print("$e, $stacktrace");
      return null;
    }
  }

}
