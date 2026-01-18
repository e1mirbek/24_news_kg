class ArticleModel {
  final String title;
  final String link;
  final String description;
  final String category;
  final DateTime? pubDate;

  ArticleModel({
    required this.title,
    required this.link,
    required this.description,
    required this.category,
    this.pubDate,
  });

  // ЭТО НОВОЕ: Фабричный конструктор
  // Зачем: Он берет "грязный" элемент из RSS и делает "чистый" объект ArticleModel

  factory ArticleModel.fromRssItem(item) {
    // Функция-уборщик: убирает &nbsp; и HTML теги

    String cleanText(String? text) {
      if (text == null) return ' ';

      return text
          .replaceAll(
            RegExp(r'&[a-z0-9#]+;', caseSensitive: false),
            ' ',
          ) // Удаляет все HTML-сущности
          .replaceAll(RegExp(r'<[^>]*>'), '') // Удаляет теги
          .replaceAll(
            RegExp(r'\s+'),
            ' ',
          ) // Заменяет множественные пробелы и переносы на один пробел
          .trim();
    }

    return ArticleModel(
      title: cleanText(item.title),
      link: item.link ?? '',
      description: cleanText(item.description),
      category: item.categories?.isNotEmpty == true
          ? item.categories!.first.value
          : "Новости",
      pubDate: item.pubDate,
    );
  }
}
