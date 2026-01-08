import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  @override
  void initState() {
    super.initState();
    // Запускаем загрузку новостей при старте экрана
    // listen: false, так как мы здесь не слушаем изменения, а только вызываем метод
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchNews();
    });
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
        builder: (context, newsProvider, child) {
          // 1. Если загрузка
          if (newsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Если ошибка
          if (newsProvider.errorMessage.isNotEmpty) {
            return Center(child: Text('Ошибка: ${newsProvider.errorMessage}'));
          }

          // 3. Если пусто
          if (newsProvider.articles.isEmpty) {
            return const Center(child: Text('Новостей нет'));
          }

          // 4. Вывод списка
          return ListView.builder(
            itemCount: newsProvider.articles.length,
            itemBuilder: (context, index) {
              final article = newsProvider.articles[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    article.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
              );
            },
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
