// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_news_app/data.dart';
import 'package:flutter_news_app/homepage.dart';
import 'package:flutter_news_app/likedscreen.dart';
import 'package:flutter_news_app/new_details.dart';
import 'package:flutter_news_app/savedpage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Color> colors = [
    Color.fromRGBO(255, 242, 197, 1),
    Color.fromRGBO(251, 229, 225, 1),
    Color.fromRGBO(225, 241, 255, 1),
    Color.fromRGBO(234, 228, 253, 1),
  ];

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  bool hasSearched = false;
  String errorMessage = '';

  void _performSearch() async {
    final query = searchController.text.trim();
    
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a search term'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
      errorMessage = '';
      searchResults = [];
    });

    try {
      final data = await searchNews(query);
      
      final articles = (data['articles'] as List).where((article) {
        return article['title'] != null &&
               article['title'].isNotEmpty &&
               article['content'] != null &&
               article['content'].isNotEmpty;
      }).toList();

      setState(() {
        searchResults = List<Map<String, dynamic>>.from(articles);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    iconSize: 30,
                    highlightColor: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Search News',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBar(
                        hintText: "Search for news articles...",
                        controller: searchController,
                        onSubmitted: (value) => _performSearch(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: _performSearch,
                        icon: const Icon(Icons.search, size: 30),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : errorMessage.isNotEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 60,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: $errorMessage',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : !hasSearched
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 80,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Search for news articles',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : searchResults.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.article_outlined,
                                          size: 80,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'No articles found',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                        child: Text(
                                          '${searchResults.length} results found',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: searchResults.length,
                                          itemBuilder: (context, index) {
                                            final article = searchResults[index];
                                            final color = colors[index % 4];

                                            return Card(
                                              color: color,
                                              margin: const EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 4),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: ListTile(
                                                contentPadding: const EdgeInsets.all(12),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => NewDetailsScreen(
                                                        bgcolor: color,
                                                        title: article['title'] ?? 'No Title',
                                                        author: article['author'] ?? 'No Author',
                                                        description: article['description'] ??
                                                            article['content'] ??
                                                            'No Description',
                                                        content: article['content'] ?? 'No Content',
                                                        imageUrl: article['urlToImage'] ?? "",
                                                        url: article['url'] ?? "",
                                                        publishedAt: article['publishedAt'] ?? "Updated at ${DateTime.now().toIso8601String()}",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                leading: article['urlToImage'] != null &&
                                                        article['urlToImage']!.isNotEmpty
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: Image.network(
                                                          article['urlToImage']!,
                                                          width: 80,
                                                          height: 80,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error, stackTrace) {
                                                            return Container(
                                                              width: 80,
                                                              height: 80,
                                                              color: Colors.grey[300],
                                                              child: const Icon(Icons.image,
                                                                  size: 40),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 80,
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: const Icon(Icons.article,
                                                            size: 40, color: Colors.grey),
                                                      ),
                                                title: Text(
                                                  article['title'] ?? 'No Title',
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      article['author'] ?? 'No Author',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      article['description'] ?? '',
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _circleBtn(const Icon(Icons.home), false, () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage()),
                      );
                    }),
                    const SizedBox(width: 25),
                    _circleBtn(const Icon(Icons.thumb_up_alt_outlined), false, () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Likedscreen()),
                      );
                    }),
                    const SizedBox(width: 25),
                    _circleBtn(const Icon(Icons.search_rounded), true, () {}),
                    const SizedBox(width: 25),
                    _circleBtn(const Icon(Icons.save_alt), false, () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SavedNews()),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _circleBtn(Icon icon, bool isActive, void Function() func) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isActive
          ? Colors.white.withOpacity(0.85)
          : Colors.black.withOpacity(0.85),
    ),
    child: IconButton(
      onPressed: func,
      icon: icon,
      color: isActive ? Colors.black : Colors.white,
      iconSize: 35,
    ),
  );
}