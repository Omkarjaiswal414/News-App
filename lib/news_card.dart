// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_news_app/ArticlesProvider.dart';
import 'package:flutter_news_app/new_details.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class NewsCard extends StatelessWidget {
  final Color cardColor;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final String url;
  final String content;

  const NewsCard({
    super.key,
    required this.cardColor,
    required this.title,
    required this.author,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes
    final articlesProvider = Provider.of<ArticlesProvider>(context);
    final isLiked = articlesProvider.isLiked(url);
    final isSaved = articlesProvider.isSaved(url);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewDetailsScreen(
              bgcolor: cardColor,
              title: title,
              author: author,
              description: description,
              content: content,
              imageUrl: imageUrl,
              url: url,
            ),
          ),
        );
      },
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.only(left: 5, right: 5, top: 28, bottom: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                width: 50,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red,
                ),
                child: const Text(
                  "LIVE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "Updated just now",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 89, 89, 89),
                ),
              ),

              const SizedBox(height: 15),

              ListTile(
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: const NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYD1_DRpzv7wg8MSmEK8GCy8vL2chya9hHww&s",
                  ),
                  radius: 30,
                ),
                title: const Text(
                  "Published by",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 89, 89, 89),
                  ),
                ),
                subtitle: Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: Text(
                  description,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Like Button
                  _iconButton(
                    Icons.thumb_up_alt_outlined,
                    isLiked ? Colors.blue : const Color.fromARGB(255, 89, 89, 89),
                    () {
                      Provider.of<ArticlesProvider>(context, listen: false).toggleLike({
                        'title': title,
                        'author': author,
                        'description': description,
                        'content': content,
                        'imageUrl': imageUrl,
                        'url': url,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            !isLiked ? 'Added to liked articles' : 'Removed from liked articles',
                          ),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),

                  // Share Button
                  _iconButton(
                    Icons.share,
                    const Color.fromARGB(255, 89, 89, 89),
                    () {
                      Share.share(url);
                    },
                  ),
                  const SizedBox(width: 20),

                  // Save Button
                  _iconButton(
                    Icons.bookmark_add_rounded,
                    isSaved ? Colors.green : const Color.fromARGB(255, 89, 89, 89),
                    () {
                      Provider.of<ArticlesProvider>(context, listen: false).toggleSave({
                        'title': title,
                        'author': author,
                        'description': description,
                        'content': content,
                        'imageUrl': imageUrl,
                        'url': url,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            !isSaved ? 'Added to saved articles' : 'Removed from saved articles',
                          ),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _iconButton(IconData icon, Color col, void Function() func) {
  return Container(
    decoration: const BoxDecoration(
      color: Color.fromRGBO(245, 231, 190, 1),
      shape: BoxShape.circle,
    ),
    child: IconButton(
      icon: Icon(icon),
      iconSize: 25,
      color: col,
      onPressed: func,
    ),
  );
}