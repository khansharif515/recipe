import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class RecipeDetail extends StatefulWidget {
  RecipeDetail({
    this.title,
    this.imageUrl,
    this.ingredients,
    this.sourceName,
    this.sourceUrl,
    this.siteUrl,
    this.prepTime,
    this.cookTime,
    this.totalTime,
    this.servings,
    this.notes,
    this.name,
  });
  final String title;
  final String imageUrl;
  final List<dynamic> ingredients;
  final String sourceName;
  final String sourceUrl;
  final String siteUrl;
  final String prepTime;
  final String cookTime;
  final String totalTime;
  final String servings;
  final String notes;
  final String name;

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  // Future<void> _launched;
  // Future<void> _launchInBrowser(String url) async {
  //   if (await canLaunch(url)) {
  //     launch(
  //       url,
  //       forceSafariVC: true,
  //       // forceWebView: false,
  //       enableJavaScript: true,
  //       //headers: <String, String>{'my_header_key': 'my_header_value'},
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Widget _tabSection(BuildContext context) {
    final mq = MediaQuery.of(context);
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
              tabs: [
                Tab(text: "Overview"),
                Tab(text: "Ingredients"),
                Tab(text: "Source"),
              ],
              labelColor: Colors.blue,
            ),
          ),
          //Overview
          Container(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      '${widget.notes}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.room_service),
                        SizedBox(width: 8),
                        Text('Servings:'),
                        Spacer(),
                        Text('${widget.servings} Serves',style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.timer),
                        SizedBox(width: 8),
                        Text('Preparation Time:'),
                        Spacer(),
                        Text('${widget.prepTime}',style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.av_timer),
                        SizedBox(width: 8),
                        Text('Cook Time:'),
                        Spacer(),
                        Text('${widget.cookTime}',style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.access_time),
                        SizedBox(width: 8),
                        Text('Total Time:'),
                        Spacer(),
                        Text('${widget.totalTime} Mins',style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
              //Ingredients
              Container(
                  child: Column(
                children: <Widget>[
                  ...widget.ingredients
                      .map((e) => Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.check_box),
                                SizedBox(width: 10),
                                Text(
                                  e,
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              )),
              //Source
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      '${widget.name}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      onPressed: () {
                        setState(() async {
                          const url = 'https://flutter.dev';
                          if (await canLaunch(url)) {
                            await launch(
                              url,
                              forceSafariVC: true,
                              enableJavaScript: true,
                            );
                          } else {
                            throw 'Could not launch $url';
                          }
                        });
                      },
                      child: Text('Source of the Recipe'),
                    ),
                    RaisedButton(
                      onPressed: () => setState(() {
                        //_launchInBrowser(widget.siteUrl);
                      }),
                      child: Text('More Recipe'),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.sourceUrl);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              child: Image.network(widget.imageUrl),
            ),
            SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            _tabSection(context),
          ],
        ),
      ),
    );
  }
}
