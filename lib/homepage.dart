// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_news_app/data.dart';
import 'package:flutter_news_app/news_card.dart';
import 'package:tcard/tcard.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> filter = const ['Trending', 'Business','Entertainment','Sports',  'Health', 'Technology'];
  late String selectedfilter;

  final List<Color> colors = [
      Color.fromRGBO(255, 242, 197, 1),
      Color.fromRGBO(251, 229, 225, 1),
      Color.fromRGBO(225, 241, 255, 1),
      Color.fromRGBO(234, 228, 253, 1),
    ];
    
  late List<NewsCard> newsCards;
  

  
  final TCardController _controller = TCardController();

  @override
  void initState() {
    super.initState();
    selectedfilter = filter[0];
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:FutureBuilder(
          future: fetchData(selectedfilter),
          builder: (context, snapshot){

              if(snapshot.hasError){
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }

              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }

              final data= snapshot.data!;

              data['articles'].removeWhere((article) {
                      return article['title'] == null ||
                            article['title'].isEmpty ||
                            article['content'] == null ||
                            article['content'].isEmpty;
                    });
              
              int noOfArticles = data['articles'].length ;

              if(noOfArticles==0){
                return  Center(
                  child: Text("No Articles Found"),
                );
              }

            
              
            newsCards = List.generate(
              noOfArticles,
              (index) => NewsCard(
                cardColor: colors[index % 4],
                title: data['articles'][index]['title']==null|| data['articles'][index]['title']==""? "No Title": data['articles'][index]['title'] ,

                author: data['articles'][index]['author']==null|| data['articles'][index]['author']==""? "No Author":data['articles'][index]['author'],

                description: data['articles'][index]['description']==null|| data['articles'][index]['description']==""? data['articles'][index]['content']!:data['articles'][index]['description'],
                url: data['articles'][index]['url']
               ),
            );

            return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Icon(Icons.newspaper, size: 30),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text('Newz App',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          Icon(Icons.tune, size: 30),
                        ],
                      ),
                    
                      SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filter.length,
                          itemBuilder: (context, index){
                            final select = filter[index];
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedfilter =  select;
                                });
                              },
                              child: Container(
                                alignment: AlignmentDirectional.bottomCenter,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                    select,
                                    style: TextStyle(
                                      fontWeight: selectedfilter==select? 
                                      FontWeight.bold: FontWeight.normal,
                                      fontSize: selectedfilter==filter[index]? 24:16,
                                    ),
                                  ),
                              ),
                            );
                          },
                          ),
                      ),
                      
                    Expanded(
                      
                      child: TCard( 
                        controller: _controller,
                        size: const Size(double.infinity, double.infinity), // fixed card size
                        cards: newsCards,
                        onEnd: () {
                          // Restart cards automatically
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _controller.reset();
                          });},
                        )
                        
                        ),
              
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _circleBtn(Icon(Icons.home),(){}),
                                const SizedBox(width: 25),
                                _circleBtn(Icon(Icons.thumb_up_alt_outlined),(){}),
                                const SizedBox(width: 25),
                                _circleBtn(Icon(Icons.search_rounded),(){}),
                                const SizedBox(width: 25),
                                _circleBtn(Icon(Icons.save_alt_rounded),(){}),
                                const SizedBox(width: 25),
                                _circleBtn(Icon(Icons.arrow_back),(){
                                  _controller.back();
                                },),
                              ],
                            ),
                        ),       
                    ],
                  ),
                ),
          );},
        )
      )
    ;
  }
}

 Widget _circleBtn(Icon icon, void Function() func){
    return Container(
      //padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.85),
      ),
      child: IconButton(onPressed: func ,icon: icon, color: Colors.white, iconSize: 35,),
    );
  }

