import 'package:flutter/cupertino.dart';
import 'package:news24_kg/models/article_model.dart';
import 'package:news24_kg/services/rss_service.dart';

class NewsProvider extends ChangeNotifier {
  final RssService _rssService = RssService();

  // state for UI

  List<ArticleModel> _allArticles = [];
  List<String> _categories = ['Все'];
  String _selectedCategories = 'Все';
  final List<String> _categoryOrder = [
    'Все',
    'Власть',
    'Экономика',
    'Общество',
    'Проишествия',
    'Мир',
    'Техноблог',
  ];

  bool _isLoading = false;
  String _errorMessage = '';

  // getter

  List<ArticleModel> get allArticles => _allArticles;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  RssService get rssService => _rssService;

  List<String> get categories => _categories;

  String get selectedCategories => _selectedCategories;

  List<String> get categoryOrder => _categoryOrder;

  // methods

  /// метод загрузки новостей
  Future<void> fetchNews() async {
    _isLoading = true;

    _errorMessage = '';

    notifyListeners();

    try {
      _allArticles = await _rssService.getFeed();

      // 1. Получаем уникальные категории из новостей
      final uniqueCategories = _allArticles
          .map((e) => e.category)
          .where((c) => c.isNotEmpty) // Убираем пустые, если есть
          .toSet()
          .toList();

      // 2. Сортируем их согласно нашему списку _categoryOrder
      uniqueCategories.sort((a, b) {
        int indexA = _categoryOrder.indexOf(a);
        int indexB = _categoryOrder.indexOf(b);

        // Если категории нет в нашем списке приоритетов, кидаем её в конец
        if (indexA == -1) indexA = 999;
        if (indexB == -1) indexB = 999;

        return indexA.compareTo(indexB);
      });

      // 3. Формируем итоговый список (Все + отсортированные)
      _categories = ['Все', ...uniqueCategories];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// логика фильтраций
  /// Если выбрано "Все" -> отдаем весь список.
  /// Если выбрано другая категория -> отдаем только статьи с определенными новостями.

  List<ArticleModel> get articles {
    if (_selectedCategories == 'Все') {
      return _allArticles;
    }
    return _allArticles
        .where((article) => article.category == _selectedCategories)
        .toList();
  }
}
