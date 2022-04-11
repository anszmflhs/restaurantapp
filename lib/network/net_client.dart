import 'dart:convert';
import 'package:http/http.dart';
import 'package:restaurantapp/model/response_filter.dart';

class NetClient {
  String url = "https://www.themealdb.com/api/json/v1/1/";
  late String endpoint;

  Future<ResponseFilter?> fetchDataMeals(int currentIndex) async {
    if (currentIndex == 0) {
      endpoint = "filter.php?c=Seafood";
    } else {
      endpoint = "filter.php?a=Canadian";
    }
    try {
      var res = await get(Uri.parse(url + endpoint));
      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);
        ResponseFilter data = ResponseFilter.fromJson(json);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
