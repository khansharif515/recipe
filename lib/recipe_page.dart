import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipePage extends StatefulWidget {
  final String token;
  RecipePage({this.token});
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  bool isLoading = true;
  dynamic recipeData;
  @override
  initState(){
    super.initState();
    getRecipe();
  }

  getRecipe() async{
    var rUrl = 'https://rcapp.utech.dev/api/recipes';
    await http.get(rUrl,
        headers: {
        "Authorization" : "Bearer ${widget.token}"
    }).then((value){
      print(value.statusCode);
      print(value.body);
      if (value.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        var data = json.decode(value.body);
        recipeData = data;

      } else {
        setState(() {
          isLoading = false;
        });
        print(value.body);

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recipe"),),
      body:
      isLoading?Center(child: CircularProgressIndicator(),):
      Container(
        child: ListView.builder(
          itemCount: recipeData["data"].length,
          itemBuilder: (BuildContext ctx, int index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  children: [
                    Image.network(recipeData["data"][index]["image_url"]),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(recipeData["data"][index]["title"].toString()),
                        )),
                    //Add more

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
