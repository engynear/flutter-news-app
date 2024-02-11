import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/news_service.dart';
import '../widgets/news_tile.dart';
import 'news_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NewsCategory {
  final String name;
  final IconData icon;

  NewsCategory({required this.name, required this.icon});
}

final List<NewsCategory> categories = [
  NewsCategory(name: 'business', icon: Icons.business),
  NewsCategory(name: 'health', icon: Icons.healing),
  NewsCategory(name: 'technology', icon: Icons.computer),
  NewsCategory(name: 'sports', icon: Icons.directions_run),
];

final List<String> countries = ['RU', 'US'];

Future<void> saveCountry(String country) async {
  final box = Hive.box('settingsBox');
  await box.put('country', country);
}

Future<void> saveCategory(String category) async {
  final box = Hive.box('settingsBox');
  await box.put('category', category);
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String _currentCountry = 'US';
  String _currentCategory = 'business';

  List<News> newsList = [];
  int currentPage = 1;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    await Hive.openBox('settingsBox');
    final box = Hive.box('settingsBox');
    final String country = box.get('country', defaultValue: 'US');
    final String category = box.get('category', defaultValue: 'business');

    setState(() {
      _currentCountry = country;
      _currentCategory = category;
    });
    loadNews();
  }

  void toggleCountry() {
    setState(() {
      final int currentIndex = countries.indexOf(_currentCountry);
      _currentCountry = countries[(currentIndex + 1) % countries.length];
      currentPage = 1;
    });
    saveCountry(_currentCountry);
    loadNews();
  }

  void selectCategory(String category) {
    setState(() {
      _currentCategory = category;
      currentPage = 1;
    });
    saveCategory(_currentCategory);
    loadNews();
  }

  void loadNews() async {
    List<News> loadedNews = await NewsService().fetchNewsByCategoryAndCountry(
        _currentCategory, _currentCountry.toLowerCase(),
        page: currentPage);
    setState(() {
      newsList = loadedNews;
    });
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
    loadNews();
  }

  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      loadNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('engynear`s news'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: newsList.length + 1,
              itemBuilder: (context, index) {
                if (index == newsList.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: currentPage > 1 ? previousPage : null,
                              child: const Text('Previous Page'),
                            ),
                            ElevatedButton(
                              onPressed: newsList.length > 1 ? nextPage : null,
                              child: const Text('Next Page'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }
                return NewsTile(
                  title: newsList[index].title,
                  description: newsList[index].description,
                  imageUrl: newsList[index].urlToImage,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          NewsDetailPage(news: newsList[index]),
                    ));
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleCountry,
        child: Text(_currentCountry),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List<Widget>.generate(categories.length, (index) {
            return IconButton(
              icon: Icon(categories[index].icon),
              onPressed: () => selectCategory(categories[index].name),
              color: _currentCategory == categories[index].name
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
            );
          })
            ..insert(
                categories.length ~/ 2,
                const SizedBox(
                    width:
                        48)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.box('settingsBox').close();
    super.dispose();
  }
}
