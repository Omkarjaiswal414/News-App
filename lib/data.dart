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
        // headers: {
        //   'Authorization': 'Bearer $apikey',
        // }
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