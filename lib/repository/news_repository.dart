import 'package:news24_kg/data/models/article_model.dart';
import 'package:news24_kg/data/services/rss_service.dart';

class NewsRepository {
  final RssService _rssService;
  NewsRepository({required RssService rssService}) : _rssService = rssService;
  Future<List<ArticleModel>> fetchAllNews() => _rssService.getFeed();
}
