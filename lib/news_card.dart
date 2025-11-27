// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_news_app/new_details.dart';
import 'package:share_plus/share_plus.dart';

class NewsCard extends StatefulWidget {
  final Color cardColor;

  final String title;
  final String author;
  final String description;
  final String url;


  const NewsCard({super.key, 
  required this.cardColor,
  required this.title,
  required this.author,
  required this.description,
  required this.url  
  });



  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=> NewDetailsScreen(
            bgcolor: widget.cardColor,
            title: widget.title,
            author: widget.author,
            description: widget.description,
            url: widget.url,
            )
          ));
      },
      child: Card(
        elevation: 10,
          margin: EdgeInsets.only(left:5, right:5, top:28, bottom:15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: widget.cardColor,
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
                  child: Text("LIVE",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                  )
                          )
                  ),
                SizedBox(height: 8, 
                ),
      
                Text(
                  widget.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
      
                SizedBox(height: 10),
                Text("Updated just now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 89, 89, 89),
                        ),
                  ),
                
                SizedBox(height: 15),
      
                ListTile(
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYD1_DRpzv7wg8MSmEK8GCy8vL2chya9hHww&s"),
                    radius: 30,
                  ),
                  title: Text("Published by",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 89, 89, 89),
                              ),
                          ),
                  subtitle: Text(widget.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                              ),
                ),
      
                SizedBox(height: 10),
      
                Expanded(
                  child: Text(widget.description,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                      ),
                  ),
      
                SizedBox(height: 15),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _iconButton(Icons.thumb_up_alt_outlined,(){}),
                    SizedBox(width: 20),
                    _iconButton(Icons.share,(){
                      Share.share(widget.url);
                    }),
                    SizedBox(width: 20),
                    _iconButton(Icons.bookmark_add_rounded,(){}),
                  ],
                ),
              ],
            ),
          ),
      ),
    );
  }
}

Widget _iconButton(IconData icon, void Function() func){
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromRGBO(245, 231, 190, 1),  // similar pale yellow like screenshot
      shape: BoxShape.circle
    ),
    child: IconButton(icon:Icon(icon),
                      iconSize: 25, 
                      color: Color.fromARGB(255, 89, 89, 89), 
                      onPressed: func
                      ),
  );
}