import 'dart:convert';
import 'dart:developer' as dev;

import 'package:news24_kg/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed_plus/domain/rss_feed.dart';

class RssService {
  final _targetUrl = "https://24.kg/rss/";

  // точка входа и оброботка данных

  Future<List<ArticleModel>> getFeed() async {
    try {
      final responce = await http.get(Uri.parse(_targetUrl));

      if (responce.statusCode == 200) {
        // декодировка криллицы

        final decodedBody = utf8.decode(responce.bodyBytes);

        // Парсим XML строку в RssFeed объект

        final feed = RssFeed.parse(decodedBody);

        final List<ArticleModel> articles =
            // Переводим чужой формат (RSS)
            // → в наш чистый формат (Model)
            feed.items?.map((item) {
              return ArticleModel.fromRssItem(item);
            }).toList() ??
            [];

        return articles;
      } else {
        throw Exception("Ошибка загрузкий : ${responce.statusCode} ");
      }
    } catch (e) {
      throw Exception('Ошибка : $e');
    }
  }
}
