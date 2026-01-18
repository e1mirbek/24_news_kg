import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news24_kg/data/models/article_model.dart';
import 'package:news24_kg/repository/news_repository.dart';

import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _newsRepository;

  List<ArticleModel> _allArticlesCashe = [];

  final List<String> _categoryOrder = [
    'Все',
    'Власть',
    'Экономика',
    'Общество',
    'Проишествия',
    'Мир',
    'Техноблог',
  ];

  NewsCubit(this._newsRepository) : super(LoadingNewsState());

  /// METHOD 1: Loading data
  Future<void> fetchNews() async {
    try {
      emit(LoadingNewsState());

      final articles = await _newsRepository.fetchAllNews();
      _allArticlesCashe = articles;

      final uniqueCategories = articles
          .map((e) => e.category)
          .where((c) => c.isNotEmpty)
          .toSet()
          .toList();

      uniqueCategories.sort((a, b) {
        int indexA = _categoryOrder.indexOf(a);
        int indexB = _categoryOrder.indexOf(b);
        return (indexA == -1 ? 999 : indexA).compareTo(
          indexB == -1 ? 999 : indexB,
        );
      });

      emit(
        SuccessNews(
          articles: articles,
          categories: ['Все', ...uniqueCategories],
          selectedCategory: 'Все',
        ),
      );
    } catch (e) {
      emit(ErrorNews(message: e.toString()));
    }
  }

  /// METHOD 2: Filtering Logic
  void changeCategory(String category) {
    if (state is SuccessNews) {
      final currentState = state as SuccessNews;

      final filteredList = category == 'Все'
          ? _allArticlesCashe
          : _allArticlesCashe.where((a) => a.category == category).toList();

      emit(
        SuccessNews(
          articles: filteredList,
          categories: currentState.categories,
          selectedCategory: category,
        ),
      );
    }
  }
}
