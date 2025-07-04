class Article {

  static const String statusBuy = "buy";
  static const String statusNone = "none";
  static const String statusBought = "bought";

  final String name;
  final String img;
  final String status;

  Article(this.name, this.img, this.status);

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      json['name'] ?? 'Unknown',
      json['img'] ?? 'Unknown',
      json['status'] ?? statusNone,
    );
  }
}