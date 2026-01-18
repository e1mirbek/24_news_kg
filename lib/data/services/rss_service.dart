import 'dart:convert';
import 'package:news24_kg/data/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed_plus/domain/rss_feed.dart';

class RssService {
  final _targetUrl = "https://24.kg/rss/";
  Future<List<ArticleModel>> getFeed() async {
    try {
      final responce = await http.get(Uri.parse(_targetUrl));
      if (responce.statusCode == 200) {
        final decodedBody = utf8.decode(responce.bodyBytes);
        final feed = RssFeed.parse(decodedBody);

        final List<ArticleModel> articles =
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
