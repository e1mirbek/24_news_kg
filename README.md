# 🇰🇬 KG News Reader (MVP)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow?style=for-the-badge)

Мобильное приложение на Flutter для чтения новостей Кыргызстана в реальном времени. Проект агрегирует данные с информационного портала **24.kg** через RSS-протокол.

## 📱 Скриншоты



## 🚀 О проекте

Это учебный Pet-проект, демонстрирующий работу с сетевыми запросами и архитектурой во Flutter. Приложение парсит XML-ленту новостей, обрабатывает данные и отображает их в удобном интерфейсе.

### Основные возможности:
* ✅ **RSS Parsing:** Чтение и обработка XML-фида новостей (webfeed_plus).
* ✅ **State Management:** Управление состоянием через **Provider**.
* ✅ **Error Handling:** Обработка ошибок сети и пустых состояний.
* ✅ **Clean UI:** Использование Material Design 3.
* ✅ **Encoding:** Корректная работа с кириллицей (UTF-8).

## 🛠 Технический стек

* **Framework:** Flutter / Dart
* **Architecture:** Layered Architecture (Service -> Provider -> UI)
* **Networking:** `http`, `webfeed_plus`
* **State Management:** `provider`
* **Tools:** VS Code, Git

## 🏁 Как запустить проект

1. **Клонируйте репозиторий:**
   ```bash
   git clone [https://github.com/e1mirbek/24_news_kg.git](https://github.com/e1mirbek/24_news_kg.git)

