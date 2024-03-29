import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './views/video_cell.dart';

void main() => runApp(RealWorldApp());

class RealWorldApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RealWorldState();
  }
}

class RealWorldState extends State<RealWorldApp> {
  var _isLoading = true;

  var videos;

  _fetchData() async {
    print("Attempting to fetch data....");

    final url = "https://api.letsbuildthatapp.com/youtube/home_feed";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final videosJson = map["videos"];

      // videosJson.forEach((video) => {print(video["name"])});
      setState(() {
        _isLoading = false;
        this.videos = videosJson;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: new Text("RealWorldApp"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () {
              _fetchData();
            },
          )
        ],
      ),
      body: new Center(
        child: _isLoading
            ? new CircularProgressIndicator()
            : new ListView.builder(
                itemCount: this.videos != null ? this.videos.length : 0,
                itemBuilder: (context, i) {
                  final video = this.videos[i];
                  return new FlatButton(
                    padding: new EdgeInsets.all(0.0),
                    child: new VideoCell(video),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new DetailPage()));
                    },
                  );
                },
              ),
      ),
    ));
  }
}

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Detail Page"),
      ),
      body: new Center(
        child: new Text("Detail detail detail"),
      ),
    );
  }
}
