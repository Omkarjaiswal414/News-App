import 'package:flutter/material.dart';
import 'package:flutter_news_app/ArticlesProvider.dart';
import 'package:flutter_news_app/homepage.dart';
import 'package:flutter_news_app/new_details.dart';
import 'package:flutter_news_app/savedpage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

class Likedscreen extends StatefulWidget {
  const Likedscreen({super.key});

  @override
  State<Likedscreen> createState() => _LikedscreenState();
}

class _LikedscreenState extends State<Likedscreen> {
  final List<Color> colors = [
    Color.fromRGBO(255, 242, 197, 1),
    Color.fromRGBO(251, 229, 225, 1),
    Color.fromRGBO(225, 241, 255, 1),
    Color.fromRGBO(234, 228, 253, 1),
  ];

  late List<Map<String, dynamic>> filteredArticles;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize filtered articles from provider
    final provider = Provider.of<ArticlesProvider>(context, listen: false);
    filteredArticles = List.from(provider.likedArticles);
  }

  void _searchArticles(String query, List<Map<String, dynamic>> allArticles) {
    setState(() {
      filteredArticles = allArticles
          .where((article) =>
              article['title']!.toLowerCase().contains(query.toLowerCase()) ||
              article['description']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _removeArticle(String url) {
    Provider.of<ArticlesProvider>(context, listen: false).removeFromLiked(url);
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to rebuild when provider changes
    return Consumer<ArticlesProvider>(
      builder: (context, articlesProvider, child) {
        final allArticles = articlesProvider.likedArticles;
        
        // Update filtered articles when allArticles changes
        if (searchController.text.isEmpty) {
          filteredArticles = List.from(allArticles);
        }

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
                          'Liked News',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchBar(
                            hintText: "Search liked articles",
                            controller: searchController,
                            onChanged: (query) => _searchArticles(query, allArticles),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _searchArticles(searchController.text, allArticles);
                            },
                            icon: const Icon(Icons.search, size: 30),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ListView with ListTile
                  Expanded(
                    child: filteredArticles.isEmpty
                        ? const Center(
                            child: Text(
                              "No liked articles found",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredArticles.length,
                            itemBuilder: (context, index) {
                              final article = filteredArticles[index];
                              final color = colors[index % 4];

                              return Card(
                                color: color,
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                                          title: article['title']!,
                                          author: article['author']!,
                                          description: article['description']!,
                                          content: article['content']!,
                                          imageUrl: article['urlToImage'] ?? "",
                                          url: article['url']!,
                                        ),
                                      ),
                                    );
                                  },
                                  leading: article['urlToImage'] != null && article['urlToImage']!.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            article['urlToImage']!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.image, size: 40),
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
                                          child: const Icon(Icons.article, size: 40, color: Colors.grey),
                                        ),
                                  title: Text(
                                    article['title']!,
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
                                        article['author']!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Share.share(article['url']!);
                                            },
                                            icon: const Icon(Icons.share),
                                            iconSize: 20,
                                            color: Colors.black87,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("Remove Article"),
                                                    content: const Text(
                                                        "Do you want to remove this article from liked?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text(
                                                          "No",
                                                          style: TextStyle(color: Colors.blue),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          _removeArticle(article['url']!);
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text(
                                                          "Yes",
                                                          style: TextStyle(color: Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.delete),
                                            iconSize: 20,
                                            color: Colors.red,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 10),

                  // Bottom Navigation
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
                        _circleBtn(const Icon(Icons.thumb_up_alt_outlined), true, () {}),
                        const SizedBox(width: 25),
                        _circleBtn(const Icon(Icons.search_rounded), false, () {}),
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
      },
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