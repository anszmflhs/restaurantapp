// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:restaurantapp/model/response_filter.dart';

import '../network/net_client.dart';
import '../ui/list_meals.dart';
import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  ResponseFilter? responseFilter;
  bool isLoading = true;

  void fetchDataMeals() async {
    try {
      NetClient client = NetClient();
      var data = await client.fetchDataMeals(currentIndex);
      setState(() {
        responseFilter = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataMeals();
  }

  @override
  Widget build(BuildContext context) {
    var listNav = [listMeals(responseFilter), listMeals(responseFilter)];
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FavoritePage(indexNav: currentIndex)));
            },
            icon: Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: Center(
          child: isLoading == false
              ? listNav[currentIndex]
              : CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Seafood"),
          BottomNavigationBarItem(icon: Icon(Icons.cake), label: "Dessert"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          fetchDataMeals();
        },
      ),
    );
  }
}
