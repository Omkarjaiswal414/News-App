// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_news_app/ArticlesProvider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewDetailsScreen extends StatefulWidget {
  final String title;
  final String author;
  final String description;
  final String content;
  final String url;
  final Color bgcolor;
  final String imageUrl;
  final String publishedAt;

  const NewDetailsScreen({
    super.key, 
    required this.bgcolor,
    required this.title,
    required this.author,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.url,
    required this.publishedAt,
  });

  @override
  State<NewDetailsScreen> createState() => _NewDetailsScreenState();
}

class _NewDetailsScreenState extends State<NewDetailsScreen> {
  String _getTimeAgo() {
    try {
      final publishedDate = DateTime.parse(widget.publishedAt);
      return "Updated at ${timeago.format(publishedDate, locale: 'en')}";
    } catch (e) {
      return 'Updated recently';
    }
  }

  @override
  Widget build(BuildContext context) {
    final articlesProvider = Provider.of<ArticlesProvider>(context);
    final isLiked = articlesProvider.isLiked(widget.url);
    final isSaved = articlesProvider.isSaved(widget.url);

    return Scaffold(
      backgroundColor: widget.bgcolor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: widget.bgcolor,
                flexibleSpace: Text(""),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Color.fromRGBO(180, 180, 180, 0.23),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Text(
                        _getTimeAgo(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 97, 97, 97),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.pink.shade100,
                            child: const Icon(Icons.person, color: Colors.pink),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Author',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 97, 97, 97),
                                ),
                              ),
                              Text(
                                widget.author,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),                          
                        ],
                      ),

                      const SizedBox(height: 24),
            
                      if (widget.imageUrl != "") ...[
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 300,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.medical_services, size: 80),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        widget.content,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 100),                    
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            right: 20,
            bottom: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFloatingButton(
                  isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  isLiked ? Colors.blue : Colors.white,
                  () {
                    Provider.of<ArticlesProvider>(context, listen: false).toggleLike({
                      'title': widget.title,
                      'author': widget.author,
                      'description': widget.description,
                      'content': widget.content,
                      'imageUrl': widget.imageUrl,
                      'url': widget.url,
                      'publishedAt': widget.publishedAt,
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
                const SizedBox(width: 12),
                _buildFloatingButton(
                  isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  isSaved ? Colors.green : Colors.white,
                  () {
                    Provider.of<ArticlesProvider>(context, listen: false).toggleSave({
                      'title': widget.title,
                      'author': widget.author,
                      'description': widget.description,
                      'content': widget.content,
                      'imageUrl': widget.imageUrl,
                      'url': widget.url,
                      'publishedAt': widget.publishedAt,
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
                const SizedBox(width: 12),
                _buildFloatingButton(
                  Icons.share_outlined,
                  Colors.white,
                  () {
                    Share.share(widget.url);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildFloatingButton(IconData icon, Color iconColor, void Function() func) {
  return Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.7),
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(icon, color: iconColor),
      onPressed: func,
    ),
  );
}