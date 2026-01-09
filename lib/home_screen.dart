import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news24_kg/models/article_model.dart';
import 'package:news24_kg/theme/app_colors.dart';
import 'package:news24_kg/widgets/app_icon_button.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _isScrolled = false;

  /// логика шторки при нажатий
  void _showNewsDetails(BuildContext context, ArticleModel article) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          builder: (context, scrollControllerer) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: BoxDecoration(color: AppColors.red),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Запускаем загрузку новостей при старте экрана
    // listen: false, так как мы здесь не слушаем изменения, а только вызываем метод
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchNews();
    });

    _scrollController.addListener(() {
      if (_scrollController.offset > 1 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 1 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
      }
    });

    @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return ' ';

    // 'd MMMM, HH:mm' сделает "6 января, 16:52"
    // 'ru' - локаль (язык), чтобы месяц был на русском
    return DateFormat('d MMMM, HH:mm', 'ru').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(),
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          // 1. Если загрузка
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Если ошибка
          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text('Ошибка: ${provider.errorMessage}'));
          }

          // 3. Если пусто
          if (provider.articles.isEmpty) {
            return const Center(child: Text('Новостей нет'));
          }

          // 4. Вывод списка
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50.0,
                  child: ListView.builder(
                    itemCount: provider.categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final category = provider.categories[index];
                      final isSelected = category == provider.selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? AppColors.red
                                : AppColors.backgroundCard,
                            foregroundColor: isSelected
                                ? AppColors.white
                                : AppColors.black,
                          ),
                          onPressed: () => provider.changeCategory(category),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: _isScrolled
                            ? [
                                AppColors.background,
                                Colors.white70,
                                Colors.white24,
                              ]
                            : [Colors.white, Colors.white70, Colors.white24],
                        stops: [0.0, 0.85, 1.0],
                      ).createShader(bounds);
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: provider.articles.length,
                      itemBuilder: (context, index) {
                        final article = provider.articles[index];
                        return InkWell(
                          onTap: () => _showNewsDetails(context, article),
                          child: Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(
                                article.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    _formatDate(article.pubDate),
                                  ), // Потом отформатируем красиво
                                  const SizedBox(height: 5),
                                  Text(
                                    article.description.replaceAll(
                                      RegExp(r'<[^>]*>'),
                                      '',
                                    ), // Убираем HTML теги из описания
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: false,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.red,
            ),
            child: Text(
              "kg".toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            "News KG",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const Spacer(),
          AppIconButton(
            icon: Icons.refresh_outlined,
            color: AppColors.grey,
            onPressed: () =>
                Provider.of<NewsProvider>(context, listen: false).fetchNews(),
          ),
          AppIconButton(
            icon: Icons.notifications_outlined,
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }
}
