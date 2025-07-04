import 'package:hive_ce_flutter/adapters.dart';
import 'hive/hive_adapters.dart';

import 'article.dart';

class DB {
  static late Box box;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ArticleAdapter());
    box = await Hive.openBox("data");
  }

  static Future<void> setArticleStatus(String name, String status) async {
    Article article = box.get(name);
    await box.put(name, Article(article.name, article.img, status) );
  }

  static Future<void> resetAllStatus() async {
    for (var article in box.keys) {
      await setArticleStatus(article, Article.statusNone);
    }
  }

  static List<Article> getAllArticles() {
    List<Article> articles = [];
    for (var item in box.keys) {
      articles.add(box.get(item));
    }
    return articles;
  }

  static Future<void> prepareArticles(List<Article> articles) async {
    for (Article item in articles) {
      if (!box.containsKey(item.name)) {
        await box.put(item.name, item);
      }
    }
  }

  static Future<void> setNextStatus(Article article) async {
    switch (article.status) {
      case Article.statusNone:
        await setArticleStatus(article.name, Article.statusBuy);
        break;
      case Article.statusBuy:
        await setArticleStatus(article.name, Article.statusBought);
        break;
      case Article.statusBought:
        await setArticleStatus(article.name, Article.statusNone);
        break;
    }
  }
}
