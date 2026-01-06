import 'package:flutter/cupertino.dart';
import 'package:news24_kg/models/article_model.dart';
import 'package:news24_kg/services/rss_service.dart';

class NewsProvider extends ChangeNotifier {
  final RssService _rssService = RssService();

  // state

  List<ArticleModel> _articles = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // getter for UI

  List<ArticleModel> get articles => _articles;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Future<void> fetchNews() async {
    _isLoading = true;

    _errorMessage = '';

    notifyListeners();

    try {
      _articles = await _rssService.getFeed();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
