import 'package:equatable/equatable.dart';

import '../../data/models/article_model.dart';

class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingNews extends NewsState {}

class ErrorReceivingData extends NewsState {
  final String message;

  ErrorReceivingData({required this.message});

  @override
  List<Object?> get props => [message];
}

class SuccessNews extends NewsState {
  final List<ArticleModel> articles;

  SuccessNews({required this.articles});

  @override
  List<Object?> get props => [articles];
}
