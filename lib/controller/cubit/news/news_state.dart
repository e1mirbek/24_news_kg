import 'package:equatable/equatable.dart';
import 'package:news24_kg/data/models/article_model.dart';

abstract class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingNewsState extends NewsState {}

class ErrorNews extends NewsState {
  final String message;
  ErrorNews({required this.message});

  @override
  List<Object?> get props => [message];
}

class SuccessNews extends NewsState {
  final List<ArticleModel> articles;
  final List<String> categories;
  final String selectedCategory;

  SuccessNews({
    required this.articles,
    required this.categories,
    required this.selectedCategory,
  });

  @override
  List<Object?> get props => [articles, categories, selectedCategory];
}
