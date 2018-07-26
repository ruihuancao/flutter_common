
class Movie {

  final String name;
  final String link;
  final String category;
  final String date;


  Movie({this.name, this.link, this.category, this.date});

  Movie.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        link = json['link'],
        category = json['category'],
        date = json['date'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'link': link,
        'category': category,
        'date': date,
      };
}