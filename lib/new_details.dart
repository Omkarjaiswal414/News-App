// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class NewDetailsScreen extends StatefulWidget {
  final String title;
  final String author;
  final String description;
  final String url;
  final Color bgcolor;

  const NewDetailsScreen({super.key, 
  required this.bgcolor,
  required this.title,
  required this.author,
  required this.description,
  required this.url
  });

  @override
  State<NewDetailsScreen> createState() => _NewDetailsScreenState();
}

class _NewDetailsScreenState extends State<NewDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor:widget.bgcolor,
        body: Stack(
        children: [
            CustomScrollView(
                slivers: [
                    SliverAppBar(
                        backgroundColor: widget.bgcolor,
                        flexibleSpace:Text(""),
                        leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            style: IconButton.styleFrom(
                                backgroundColor: Color.fromRGBO(180, 180, 180, 0.23),
                            ),
                            onPressed: (){
                              Navigator.pop(context);
                            }, 
                            icon: Icon(Icons.arrow_back, color: Colors.black,),
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
                                    //fontFamily: 
                                    ),
                                ),
                                const SizedBox(height: 12),
                                
                                
                                const Text(
                                    'Updated 1 mins ago',
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
                                            color:Color.fromARGB(255, 97, 97, 97),
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
                      
                                AspectRatio(
                                    aspectRatio: 16 / 9,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                      'https://cdn.mos.cms.futurecdn.net/sgS7A4ihiCsrLSF67nBP9Q-2000-80.jpg',
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
                                
                                // Article Text
                                Text(
                                    widget.description,
                                     style: TextStyle(
                                    fontSize: 16,
                                    height: 1.6,
                                    color: Colors.black87,
                                    ),
                                ),
                                const SizedBox(height: 24),

                                const Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
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
                    _buildFloatingButton(Icons.thumb_up_outlined,(){}),
                    const SizedBox(width: 12),
                    _buildFloatingButton(Icons.bookmark_outline,(){}),
                    const SizedBox(width: 12),
                    _buildFloatingButton(Icons.share_outlined,(){
                      Share.share(widget.url);
                    }),
                ],
                ),
            ),
        ],
        
        ),
    );
  }
}

Widget _buildFloatingButton(IconData icon,void Function() func){
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
        icon: Icon(icon, color: Colors.white),
        onPressed: func,
      ),
    );
  }
