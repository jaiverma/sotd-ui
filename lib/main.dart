import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Song {
  final String albumName;
  final List<String> artists;
  final String imageUrl;
  final String releaseDate;
  final String trackName;
  final String trackUri;
  final String trackUrl;

  Song(this.albumName, this.artists, this.imageUrl, this.releaseDate,
      this.trackName, this.trackUri, this.trackUrl);

  factory Song.fromJson(Map<String, dynamic> data) {
    final albumName = data["album_name"] as String;
    final artists = data["artists"] as List<String>;
    final image = data["image"] as String;
    final releaseDate = data["release_date"] as String;
    final trackName = data["track_name"] as String;
    final trackUri = data["track_uri"] as String;
    final trackUrl = data["track_url"] as String;

    return Song(
        albumName, artists, image, releaseDate, trackName, trackUri, trackUrl);
  }
}

class SotdApp extends StatefulWidget {
  @override
  _SotdAppState createState() => _SotdAppState();
}

class _SotdAppState extends State<SotdApp> {}
