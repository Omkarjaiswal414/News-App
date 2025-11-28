import 'package:flutter/material.dart';

class ArticlesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _likedArticles = [];
  List<Map<String, dynamic>> _savedArticles = [];

  List<Map<String, dynamic>> get likedArticles => _likedArticles;
  List<Map<String, dynamic>> get savedArticles => _savedArticles;

  // Check if article is liked
  bool isLiked(String url) {
    return _likedArticles.any((article) => article['url'] == url);
  }

  // Check if article is saved
  bool isSaved(String url) {
    return _savedArticles.any((article) => article['url'] == url);
  }

  // Toggle like status
  void toggleLike(Map<String, dynamic> articleData) {
    if (isLiked(articleData['url'])) {
      _likedArticles.removeWhere((article) => article['url'] == articleData['url']);
    } else {
      _likedArticles.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': articleData['title'],
        'author': articleData['author'],
        'description': articleData['description'],
        'content': articleData['content'],
        'urlToImage': articleData['imageUrl'],
        'url': articleData['url'],
        'liked': 'true',
        'saved': isSaved(articleData['url']) ? 'true' : 'false',
      });
    }
    notifyListeners(); // This rebuilds all listening widgets
  }

  // Toggle save status
  void toggleSave(Map<String, dynamic> articleData) {
    if (isSaved(articleData['url'])) {
      _savedArticles.removeWhere((article) => article['url'] == articleData['url']);
    } else {
      _savedArticles.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': articleData['title'],
        'author': articleData['author'],
        'description': articleData['description'],
        'content': articleData['content'],
        'urlToImage': articleData['imageUrl'],
        'url': articleData['url'],
        'liked': isLiked(articleData['url']) ? 'true' : 'false',
        'saved': 'true',
      });
    }
    notifyListeners(); // This rebuilds all listening widgets
  }

  // Remove article from liked
  void removeFromLiked(String url) {
    _likedArticles.removeWhere((article) => article['url'] == url);
    notifyListeners();
  }

  // Remove article from saved
  void removeFromSaved(String url) {
    _savedArticles.removeWhere((article) => article['url'] == url);
    notifyListeners();
  }

  // Initialize with existing data (call this in main)
  void initializeWithData(
    List<Map<String, String>> initialLiked,
    List<Map<String, String>> initialSaved,
  ) {
    _likedArticles = List<Map<String, dynamic>>.from(initialLiked);
    _savedArticles = List<Map<String, dynamic>>.from(initialSaved);
    notifyListeners();
  }
}