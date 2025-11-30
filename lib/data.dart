import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/secret.dart';
import 'package:http/http.dart' as http;

Future<Map<String,dynamic>> fetchData(String category) async {

  String country="us";

  String uri='https://newsapi.org/v2/top-headlines?country=$country&apiKey=$apikey';

  if(category!="Trending"){
    category= category.toLowerCase();
    uri='https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apikey';
  }

  try{
    final res = await http.get(
        Uri.parse(uri),
        );

    final data= jsonDecode(res.body);

    if(data['status']!="ok"){
      throw "Unexpected error occured !!!!!!";
      
    }
    debugPrint(data['articles'].toString());
    return data;

  }catch(e){
    
    throw e.toString();
  }
}


Future<Map<String,dynamic>> searchNews(String query) async {
  
  String uri='https://newsapi.org/v2/everything?q=$query&apiKey=$apikey';

  try{
    final res = await http.get(
        Uri.parse(uri),
        );

    final data= jsonDecode(res.body);

    if(data['status']!="ok"){
      throw "Unexpected error occurred while searching!";
    }
    
    debugPrint("Search results: ${data['articles'].length} articles found");
    return data;

  }catch(e){
    throw e.toString();
  }
}


var savedArticles = <Map<String, String>>[
  {
    'id':" 12",
    'title': "Private payroll losses accelerated in the past four weeks, ADP reports - CNBC",
    'author': "Jeff Cox",
    'description': "The U.S. labor market is showing further signs of weakening as the pace of layoffs has picked up over the past four weeks, payrolls processing firm ADP reported Tuesday.\r\nPrivate companies lost an avÃ¢â‚¬Â¦ [+1456 chars]",
    'content':"The U.S. labor market is showing further signs of weakening as the pace of layoffs has picked up over the past four weeks, payrolls processing firm ADP reported Tuesday.\r\nPrivate companies lost an avÃ¢â‚¬Â¦ [+1456 chars]",
    'urlToImage':"https://image.cnbcfm.com/api/v1/image/108228688-1763588355689-gettyimages-2247519637-jr_12638_mensqoss.jpeg?v=1763588472&w=1920&h=1080",
    'url': "https://www.cnbc.com/2025/11/25/private-payroll-losses-accelerated-in-the-past-four-weeks-adp-reports-.html",
    'publishedAt': "2025-11-25T13:15:09Z",
    'liked': "true",
    'saved': "true",
  },
  {
    'id':"346",
    'title': "Abercrombie shares soar 18% on Hollister growth, strong earnings beat - CNBC",
    'author': "Gabrielle Fonrouge",
    'description': "Abercrombie & Fitch's namesake banner is slowing down, but revenue is ramping up at Hollister, its teen-focused brand.",
    'content':"Shares of Abercrombie & Fitch soared 18% in premarket trading on Tuesday after the company posted 7% growth in quarterly sales and issued its holiday guidance. \r\nAbercrombie, which runs its namesÃ¢â‚¬Â¦ [+2087 chars]",
    'urlToImage':"https://image.cnbcfm.com/api/v1/image/108052688-1729806026824-gettyimages-2180831339-abricombe540368_pac1xn4q.jpeg?v=1756224041&w=1920&h=1080",
    'url': "https://www.cnbc.com/2025/11/25/abercrombie-fitch-anf-earnings-q3-2025.html",
    'publishedAt': "2025-11-25T12:30:00Z",
    'liked': "false",
    'saved': "true",
  }
];


var likedArticles = <Map<String, String>>[
  {
    'id':" 12",
    'title': "Private payroll losses accelerated in the past four weeks, ADP reports - CNBC",
    'author': "Jeff Cox",
    'description': "The U.S. labor market is showing further signs of weakening as the pace of layoffs has picked up over the past four weeks, payrolls processing firm ADP reported Tuesday.\r\nPrivate companies lost an avÃ¢â‚¬Â¦ [+1456 chars]",
    'content':"The U.S. labor market is showing further signs of weakening as the pace of layoffs has picked up over the past four weeks, payrolls processing firm ADP reported Tuesday.\r\nPrivate companies lost an avÃ¢â‚¬Â¦ [+1456 chars]",
    'urlToImage':"https://image.cnbcfm.com/api/v1/image/108228688-1763588355689-gettyimages-2247519637-jr_12638_mensqoss.jpeg?v=1763588472&w=1920&h=1080",
    'url': "https://www.cnbc.com/2025/11/25/private-payroll-losses-accelerated-in-the-past-four-weeks-adp-reports-.html",
    'publishedAt': "2025-11-25T13:15:09Z",
    'liked': "true",
    'saved': "false",
  },
  {
    'id':"346",
    'title': "Abercrombie shares soar 18% on Hollister growth, strong earnings beat - CNBC",
    'author': "Gabrielle Fonrouge",
    'description': "Abercrombie & Fitch's namesake banner is slowing down, but revenue is ramping up at Hollister, its teen-focused brand.",
    'content':"Shares of Abercrombie & Fitch soared 18% in premarket trading on Tuesday after the company posted 7% growth in quarterly sales and issued its holiday guidance. \r\nAbercrombie, which runs its namesÃ¢â‚¬Â¦ [+2087 chars]",
    'urlToImage':"https://image.cnbcfm.com/api/v1/image/108052688-1729806026824-gettyimages-2180831339-abricombe540368_pac1xn4q.jpeg?v=1756224041&w=1920&h=1080",
    'url': "https://www.cnbc.com/2025/11/25/abercrombie-fitch-anf-earnings-q3-2025.html",
    'publishedAt': "2025-11-25T12:30:00Z",
    'liked': "true",
    'saved': "true",
  }
];