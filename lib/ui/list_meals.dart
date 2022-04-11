// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:restaurantapp/model/response_filter.dart';
import 'package:restaurantapp/page/detail_page.dart';
import 'item_meals.dart';

Widget listMeals(ResponseFilter? responseFilter) {
  if (responseFilter == null) {
    return Container();
  }
  return ListView.builder(
    itemCount: responseFilter.meals!.length,
    itemBuilder: (context, index) {
      var itemMeal = responseFilter.meals?[index];

      return InkWell(
        splashColor: Colors.lightBlue,
        child: itemMeals(itemMeal?.idMeal, itemMeal?.strMeal, itemMeal?.strMealThumb),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(idMeal: itemMeal?.idMeal ?? "",)));
        },
      );
    },
  );
}