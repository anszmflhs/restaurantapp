import 'dart:convert';
// import 'dart:ui';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:restaurantapp/database/db_helper.dart';
import 'package:restaurantapp/model/meal_item.dart';
import 'package:restaurantapp/model/response_detail.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String? idMeal;

  const DetailPage({Key? key, this.idMeal}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ResponseDetail responseDetail;
  bool isLoading = true;
  bool isFavorite = false;
  var db = DBHelper();

  Future<ResponseDetail?> fetchDetail() async {
    try {
      var res = await http.get(Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.idMeal}'));

      isFavorite = await db.isFavorite(widget.idMeal);

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);
        ResponseDetail data = ResponseDetail.fromJson(json);

        if (mounted) {
          setState(() {
            responseDetail = data;
            isLoading = false;
          });
        }
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print('Failed $e');
      return null;
    }
  }

  setFavorite() async {
    var db = DBHelper();
    Meal favorite = Meal(
      idMeal: responseDetail.meals[0]['idMeal'],
      strMeal: responseDetail.meals[0]['strMeal'],
      strMealThumb: responseDetail.meals[0]['strMealThumb'],
      strInstructions: responseDetail.meals[0]['strInstructions'],
      strCategory: responseDetail.meals[0]['strCategory'],
    );
    if (!isFavorite) {
      await db.insert(favorite);
      print('Add Data');
    } else {
      await db.delete(favorite);
      print('Data Deleted');
    }
    setState(() {
      isFavorite = !isFavorite;
    });
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
        actions: [
          IconButton(
              onPressed: () {
                setFavorite();
              },
              icon: isFavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border))
        ],
      ),
      body: Center(
        child: FutureBuilder<ResponseDetail?>(
          future: fetchDetail(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
                strokeWidth: 5,
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Hero(
                        tag: '${responseDetail.meals[0]['idMeal']}',
                        child: Material(
                          child: Image.network(
                              responseDetail.meals[0]['strMealThumb']),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text('${responseDetail.meals[0]['strMeal']}'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text('Instructions'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child:
                          Text('${responseDetail.meals[0]['strInstructions']}'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
