import 'package:flutter/material.dart';
import 'package:flutter_news_app/data.dart';
import 'package:flutter_news_app/news_card.dart';
import 'package:tcard/tcard.dart';

class SavedNews extends StatefulWidget {
  const SavedNews({super.key});

  @override
  State<SavedNews> createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {
  final TCardController _controller = TCardController();

  final List<Color> colors = [
    Color.fromRGBO(255, 242, 197, 1),
    Color.fromRGBO(251, 229, 225, 1),
    Color.fromRGBO(225, 241, 255, 1),
    Color.fromRGBO(234, 228, 253, 1),
  ];

  late List<Map<String, dynamic>> allArticles;
  late List<Map<String, dynamic>> filteredArticles;
  late List<NewsCard> newsCards;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    allArticles = List.from(savedArticles);
    filteredArticles = List.from(savedArticles);

    _buildCards();
  }

  void _buildCards() {
    newsCards = List.generate(
      filteredArticles.length,
      (index) => NewsCard(
        cardColor: colors[index % 4],
        title: filteredArticles[index]['title']!,
        author: filteredArticles[index]['author']!,
        description: filteredArticles[index]['description']!,
        content: filteredArticles[index]['content']!,
        imageUrl: filteredArticles[index]['urlToImage'] ?? "",
        url: filteredArticles[index]['url']!,
      ),
    );

    setState(() {});
  }

  void _searchArticles(String query) {
    filteredArticles = allArticles
        .where((article) =>
            article['title']!.toLowerCase().contains(query.toLowerCase()) ||
            article['description']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    _controller.reset();
    _buildCards();
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
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    iconSize: 30,
                    highlightColor: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Saved News',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                        hintText: "Search saved articles",
                        controller: searchController,
                        onChanged: _searchArticles,
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
                          _searchArticles(searchController.text);
                        },
                        icon: const Icon(Icons.search, size: 30),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

             
              Expanded(
                child: filteredArticles.isEmpty
                    ? const Center(
                        child: Text(
                          "No saved articles found",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : TCard(
                        controller: _controller,
                        size: const Size(double.infinity, double.infinity),
                        cards: newsCards,
                        onEnd: () {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _controller.reset();
                          });
                        },
                      ),
              ),

              const SizedBox(height: 10),

              
              SizedBox(
                height: 40,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _circleBtn(const Icon(Icons.home), false,() {}),
                    const SizedBox(width: 25),
                    _circleBtn(const Icon(Icons.thumb_up_alt_outlined),false, () {}),
                    const SizedBox(width: 25),
                    _circleBtn(const Icon(Icons.search_rounded),false, () {}),
                    const SizedBox(width: 25),
                    _circleBtn(const Icon(Icons.save_alt),true, () {}),
                    const SizedBox(width: 25),
                    _circleBtn(const Icon(Icons.arrow_back), false,() {
                      _controller.back();
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

      color: isActive? Colors.white.withOpacity(0.85):Colors.black.withOpacity(0.85),
    ),
    child: IconButton(
      onPressed: func,
      icon: icon,
      color: isActive?Colors.black:Colors.white,
      iconSize: 35,
    ),
  );
}
