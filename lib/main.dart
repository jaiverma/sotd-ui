import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter Demo', home: SotdApp());
  }
}

class Song {
  final String albumName;
  final List<dynamic> artists;
  final String imageUrl;
  final String releaseDate;
  final String trackName;
  final String trackUri;
  final String trackUrl;

  Song(this.albumName, this.artists, this.imageUrl, this.releaseDate,
      this.trackName, this.trackUri, this.trackUrl) {}

  factory Song.fromJson(Map<String, dynamic> data) {
    final albumName = data["album_name"] as String;
    final artists = data["artists"] as List<dynamic>;
    final image = data["image"] as String;
    final releaseDate = data["release_date"] as String;
    final trackName = data["track_name"] as String;
    final trackUri = data["track_uri"] as String;
    final trackUrl = data["track_url"] as String;

    return Song(
        albumName, artists, image, releaseDate, trackName, trackUri, trackUrl);
  }
}

Future<Song> getSotd(String url) async {
  final resp = await http.get(Uri.parse(url));

  if (resp.statusCode == 200) {
    return Song.fromJson(jsonDecode(resp.body));
  } else {
    throw Exception('Failed to get song of the day :(');
  }
}

void showSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
  ));
}

class SotdApp extends StatefulWidget {
  const SotdApp({Key? key}) : super(key: key);

  @override
  _SotdAppState createState() => _SotdAppState();
}

class _SotdAppState extends State<SotdApp> {
  late Future<Song> song;

  @override
  void initState() {
    super.initState();
    song = getSotd("http://localhost:5000/get_sotd");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: getBody());
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: FutureBuilder<Song>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 20),
                          child: Container(
                            width: size.width - 100,
                            height: size.width - 100,
                            decoration: BoxDecoration(boxShadow: const [
                              BoxShadow(
                                  color: Colors.red,
                                  blurRadius: 50,
                                  spreadRadius: 5,
                                  offset: Offset(-10, 40))
                            ], borderRadius: BorderRadius.circular(20)),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 20),
                          child: Container(
                            width: size.width - 60,
                            height: size.width - 60,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        NetworkImage(snapshot.data!.imageUrl),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20)),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                          width: size.width - 80,
                          height: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  AntIcons.heartTwotone,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showSnackbar(context, "I love you Anu <3");
                                },
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    snapshot.data!.trackName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      width: 150,
                                      child: Text(
                                        snapshot.data!.albumName,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                      ))
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  AntIcons.smileFilled,
                                  color: Colors.amber,
                                ),
                                onPressed: () {
                                  showSnackbar(context, "Hiiiiii Anu :D");
                                },
                              )
                            ],
                          ))),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: size.width / 2 - 100,
                          right: size.width / 2 - 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.link,
                                color: Colors.white.withOpacity(0.8), size: 50),
                            onPressed: null,
                          ),
                          IconButton(
                            icon: Icon(Icons.play_arrow,
                                color: Colors.white.withOpacity(0.8), size: 50),
                            onPressed: null,
                          )
                        ],
                      ))
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}",
                  style: const TextStyle(fontSize: 20, color: Colors.white));
            } else {
              return const CircularProgressIndicator();
            }
          },
          future: song),
    );
  }
}



// class Snackbar extends StatefulWidget {
//   final String msg;

//   const Snackbar({Key? key, required this.msg}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _SnackbarState();
//   }
// }

// class _SnackbarState extends State<Snackbar> {
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldMessenger.of(context).hideCurrentSnackBar();
//   }
// }
