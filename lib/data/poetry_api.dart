import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_common/data/model/poetry.dart';

Future<PoetryList> fetchPoetry(int page) async {
  try{
    String url = 'http://192.168.1.186:8080/api/poetry/list?page=$page';
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return PoetryList.fromJson(data);
    } else {
      return null;
    }
  }catch(e){
    print(e);
    return null;
  }
}



