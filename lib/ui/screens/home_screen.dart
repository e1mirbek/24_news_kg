import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news24_kg/controller/cubit/news/news_cubit.dart';
import 'package:news24_kg/controller/cubit/news/news_state.dart';
import 'package:news24_kg/core/widgets/loading_indicator_widget.dart';
import 'package:news24_kg/data/models/article_model.dart';
import 'package:news24_kg/core/theme/app_colors.dart';
import 'package:news24_kg/ui/widgets/app_icon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewsCubit>();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 10, 10, 1.0),
      appBar: _appBar(),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is LoadingNewsState) {
            return const Center(child: LoadingIndicatorWidget());
          }

          if (state is ErrorNews) {
            return Center(
              child: Text(
                'Ошибка : ${state.message}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (state is SuccessNews) {
            if (state.articles.isEmpty) {
              return const Center(
                child: Text(
                  "Новостей нет",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return RefreshIndicator(
              backgroundColor: AppColors.red,
              color: AppColors.white,
              onRefresh: () => cubit.fetchNews(),
              child: CustomScrollView(
                // В реальных проектах лучше использовать CustomScrollView или Column с Expanded
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const Divider(color: Color.fromRGBO(75, 84, 98, 1.0)),
                        _buildCategories(state, cubit),
                        const Divider(color: Color.fromRGBO(75, 84, 98, 1.0)),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final article = state.articles[index];
                      return _buildNewsCard(article);
                    }, childCount: state.articles.length),
                  ),
                  // Добавляем отступ снизу, чтобы контент не перекрывался плавающей панелью из MainScreen
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCategories(SuccessNews state, NewsCubit cubit) {
    return SizedBox(
      height: 60.0,
      child: ListView.builder(
        itemCount: state.categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = state.categories[index];
          final isSelected = category == state.selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? AppColors.red
                    : const Color.fromRGBO(21, 21, 21, 1.0),
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => cubit.changeCategory(category),
              child: Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsCard(ArticleModel article) {
    return Card(
      color: const Color.fromRGBO(21, 21, 21, 1.0),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          article.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              _formatDate(article.pubDate),
              style: const TextStyle(color: Color.fromRGBO(75, 84, 98, 1.0)),
            ),
            const SizedBox(height: 5),
            Text(
              article.description.replaceAll(RegExp(r'<[^>]*>'), ''),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color.fromRGBO(150, 150, 150, 1.0)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return ' ';
    return DateFormat('d MMMM, HH:mm', 'ru').format(date);
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: const Color.fromRGBO(10, 10, 10, 1.0),
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.red,
            ),
            child: const Text(
              "KG",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "News KG",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "MEDIA PORTAL",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          AppIconButton(icon: "assets/icons/refresh.png", onPressed: () {}),
        ],
      ),
    );
  }
}
