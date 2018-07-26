import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:flutter_common/data/model/movie.dart';

void main() async{
  // 1 电影 2连续剧 3 综艺 4动漫 5动作片 6喜剧 7爱情 8科幻 9恐怖
  // 10 剧情 11战争 12 国产剧 13 香港剧 14韩国 15 欧美 16 台湾
  // 17 日本 18 海外19记录 20 微电影 21 伦理片 22 福利

  // 获取当前分类下的所有分页
//  List<String> list = await getAllPageLink(type: 1);
//  //获取第一页的电影数据
//  List<Movie> listMovies = await getPageListMovie(list[0]);
//  print(json.encode(listMovies));
//  print("-----------------------------------------------------------------");
//  获取播放链接
//  var detail = await getMovieDetail(listMovies[0].link);
//  print(json.encode(detail));

  //关键词搜索电影
  List<String> searchMoviesLink = await getSearchPageLink("活");
  print(json.encode(searchMoviesLink));

  List<Movie> listMovies = await getPageListMovie(searchMoviesLink[0]);
  print(json.encode(listMovies));
  var detail = await getMovieDetail(listMovies[0].link);
  print(json.encode(detail));
//
}

/// 获取当前类型下有多少页，返回每页链接
Future<List<String>> getAllPageLink({int type}) async{
  List<String> results = [];
  String url = "https://www.okzyw.com/?m=vod-type-id-$type.html";
  Map<String, String> headers = {
    "User-Agent" :"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1"
  };
  final response = await http.get(url, headers: headers);
  var document = parse(response.body);
  String pages = document.getElementsByClassName("pages")[0].text;
  RegExp re = new RegExp("当前:[0-9]/(.*?)页");
  Match match = re.firstMatch(pages);
  int pageCount = int.parse(match.group(1));
  print(pageCount);
  for(int i=1; i< pageCount+1; i++){
    String page = "https://okzyw.com/?m=vod-type-id-$type-pg-$i.html";
    results.add(page);
  }
  return results;
}

/// 获取页面的详情，包括播放链接
Future<Map<String, List<String>>> getMovieDetail(String url) async{
  try{
    Map<String, String> headers = {
      "User-Agent" :"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1"
    };
    final response = await http.get(url, headers: headers);
    if(response.statusCode == 200){
      return parseDetail(response.body);
    }else{
      return null;
    }
  }catch(e){
    print("has error");
    return null;
  }
}

/// 解析详情页面数据
Map<String, List<String>> parseDetail(String html){
  Map<String, List<String>> results ={};
  var document = parse(html);
  List<Element> list = document.getElementsByClassName("suf");
  for(int i=0; i< list.length; i++){
    List<Element> li = list[i].parent.nextElementSibling.children;
    List<String> sourceList = [];
    for(int j=0; j<li.length; j++){
      sourceList.add(li[j].text);
    }
    results[list[i].text] = sourceList;
  }
  return results;
}

/// 获取关键词搜索结果有多少页，返回每页链接
Future<List<String>> getSearchPageLink(String key) async{
  String url = "https://okzyw.com/index.php?m=vod-search";
  Map<String, String> headers = {
    "User-Agent" :"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1"
  };

  Map<String, String> body = {
    "wd": key,
    "submit":"search"
  };
  final response  = await http.post(url, headers: headers, body: body);

  List<String> results = [];
  var document = parse(response.body);
  String pages = document.getElementsByClassName("pages")[0].text;
  /// https://okzyw.com/index.php?m=vod-search-pg-2-wd-%E8%8A%B1.html
  RegExp re = new RegExp("当前:[0-9]/(.*?)页");
  Match match = re.firstMatch(pages);
  int pageCount = int.parse(match.group(1));
  key = Uri.encodeComponent(key);
  for(int i=1; i< pageCount+1; i++){
    String page = "https://okzyw.com/index.php?m=vod-search-pg-$i-wd-$key.html";
    results.add(page);
  }
  return results;
}

/// 从列表页面获取电影
Future<List<Movie>> getPageListMovie(String url) async{
  try{
    Map<String, String> headers = {
      "User-Agent" :"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1"
    };

    final response  = await http.get(url, headers: headers);
    if(response.statusCode == 200){
      return parseList(response.body);
    }else{
      return null;
    }
  }catch(e){
    print("has error");
    return null;
  }
}

/// 解析列表页面数据
List<Movie> parseList(String html){
  var document = parse(html);
  List<Element> vb = document.getElementsByClassName("xing_vb");
  List<Element> tt = vb[0].getElementsByClassName("tt");
  List<Movie> list = [];
  String host= "https://okzyw.com";
  for(int i =0; i<tt.length; i++){
    Element element = tt[i].parent;
    Element vb4 = element.getElementsByClassName("xing_vb4")[0];
    Element vb5 = element.getElementsByClassName("xing_vb5")[0];
    Element vb6 = element.getElementsByClassName("xing_vb6")[0];
    String link = host+vb4.getElementsByTagName("a")[0].attributes['href'];
    String name = vb4.text;
    String category = vb5.text;
    String date = vb6.text;
    Movie movie = new Movie(name: name, link: link, category: category, date: date);
    list.add(movie);
  }
  return list;
}


