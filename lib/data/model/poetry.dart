
class PoetryList {
  int totalPage;
  List<Poetry> list;

  PoetryList({this.totalPage, this.list});

  factory PoetryList.fromJson(Map<String, dynamic> data) {
    return PoetryList(
      totalPage: data['totalPage'],
      list: data['list'].map<Poetry>((json) => Poetry.fromJson(json)).toList()
    );
  }
}

class Poetry {
  final int id;
  final String name;
  final String author;
  final String content;

  Poetry({this.id, this.name, this.author, this.content});

  factory Poetry.fromJson(Map<String, dynamic> json) {
    return Poetry(
      id: json['id'],
      name: json['name'],
      author: json['poetryAuhtor'],
      content: json['content'],
    );
  }
}