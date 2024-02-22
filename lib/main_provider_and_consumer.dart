// https://chat.openai.com/share/52cb40eb-cd63-4720-8cd0-0a3152b9cd29

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class Article {
  final String id;
  final String title;
  bool isFavorite;

  Article({required this.id, required this.title, this.isFavorite = false});
}

class FavoriteArticlesViewModel extends ChangeNotifier {
  List<Article> _articles = [];

  List<Article> get articles => _articles;

  void addFavorite(String id) {
    _articles.firstWhere((article) => article.id == id).isFavorite = true;
    notifyListeners(); // Notifie les consommateurs d'un changement
  }

  void removeFavorite(String id) {
    _articles.firstWhere((article) => article.id == id).isFavorite = false;
    notifyListeners(); // Notifie les consommateurs d'un changement
  }

  // Initialisation avec des données d'exemple
  void loadArticles() {
    _articles = [
      Article(id: "1", title: "Article 1"),
      Article(id: "2", title: "Article 2"),
    ];
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        FavoriteArticlesViewModel favoriteArticlesViewModel =
            FavoriteArticlesViewModel();
        favoriteArticlesViewModel.loadArticles();

        return favoriteArticlesViewModel;
      },
      child: MaterialApp(
        home: FavoriteArticlesScreen(),
      ),
    );
  }
}

class FavoriteArticlesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Articles Favoris"),
      ),
      // body: buildConsumerVersion(),
      // body: buildProviderTrueVersion(context),
      // body: buildProviderFalseVersion(context), // Ne fonctionne pas
    );
  }

  Widget buildConsumerVersion() {
    return Consumer<FavoriteArticlesViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          itemCount: viewModel.articles.length,
          itemBuilder: (context, index) {
            var article = viewModel.articles[index];
            return ListTile(
              title: Text(article.title),
              trailing: Icon(
                article.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: article.isFavorite ? Colors.red : null,
              ),
              onTap: () {
                article.isFavorite
                    ? viewModel.removeFavorite(article.id)
                    : viewModel.addFavorite(article.id);
              },
            );
          },
        );
      },
    );
  }

  Widget buildProviderTrueVersion(BuildContext context) {
    FavoriteArticlesViewModel viewModel =
        Provider.of<FavoriteArticlesViewModel>(
      context,
      listen: true,
    );
    return ListView.builder(
      itemCount: viewModel.articles.length,
      itemBuilder: (context, index) {
        var article = viewModel.articles[index];
        return ListTile(
          title: Text(article.title),
          trailing: Icon(
            article.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: article.isFavorite ? Colors.red : null,
          ),
          onTap: () {
            article.isFavorite
                ? viewModel.removeFavorite(article.id)
                : viewModel.addFavorite(article.id);
          },
        );
      },
    );
  }

  Widget buildProviderFalseVersion(BuildContext context) {
    FavoriteArticlesViewModel viewModel =
        Provider.of<FavoriteArticlesViewModel>(
      context,
      listen: false,
    );
    return ListView.builder(
      itemCount: viewModel.articles.length,
      itemBuilder: (context, index) {
        var article = viewModel.articles[index];
        return ListTile(
          title: Text(article.title),
          trailing: Icon(
            article.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: article.isFavorite ? Colors.red : null,
          ),
          onTap: () {
            article.isFavorite
                ? viewModel.removeFavorite(article.id)
                : viewModel.addFavorite(article.id);
          },
        );
      },
    );
  }
}
