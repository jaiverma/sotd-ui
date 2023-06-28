import 'dart:math';
import 'song.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image/image.dart' as img;

final rng = Random(DateTime.now().millisecondsSinceEpoch.toInt());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff9fa5d5);
    return MaterialApp(
      title: '❤️ For Anu, Forever Ago',
      home: const SotdApp(),
      theme: ThemeData(
          splashColor: primaryColor,
          primaryColor: primaryColor,
          fontFamily: 'YanoneKaffeesatz'),
    );
  }
}

void showSnackbar(
    BuildContext context, String msg, IconData icon, Color color) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(msg),
      const SizedBox(
        width: 5,
      ),
      Icon(icon, color: color)
    ]),
  ));
}

Future<void> loadUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw "Could not launch $url";
  }
}

class SotdApp extends StatefulWidget {
  const SotdApp({Key? key}) : super(key: key);

  @override
  _SotdAppState createState() => _SotdAppState();
}

class _SotdAppState extends State<SotdApp> {
  late Future<Song> song;
  Future<void>? _launched;

  @override
  void initState() {
    super.initState();
    song = getSotd("https://sotd.jai.cafe/get_sotd");
  }

  @override
  Widget build(BuildContext context) {
    const defaultGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xff04619f), Color(0xff000000)]);
    return FutureBuilder<Song>(
        future: song,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                decoration: const BoxDecoration(gradient: defaultGradient));
          } else {
            return Container(
                child: FutureBuilder<LinearGradient>(
              builder: (context, snapshot) {
                return Container(
                    decoration: BoxDecoration(gradient: snapshot.data!),
                    child: Scaffold(
                        backgroundColor: Colors.transparent, body: getBody()));
              },
              future: getGradientFromImage(snapshot.data!.imageUrl),
              initialData: defaultGradient,
            ));
          }
        });
  }

  Widget getBody() {
    return Center(
        child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
                child: Container(
              constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
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
                                  child: Center(
                                      child: Container(
                                    width: 260,
                                    height: 260,
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Colors.red[100]!,
                                          blurRadius: 50,
                                          spreadRadius: 5,
                                          offset: const Offset(-5, 5))
                                    ], borderRadius: BorderRadius.circular(20)),
                                  ))),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, top: 20),
                                  child: Center(
                                      child: Container(
                                    width: 300,
                                    height: 300,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot.data!.imageUrl),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ))),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: SizedBox(
                                  width: 400,
                                  height: 70,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          AntIcons.heartFilled,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          showSnackbar(context, getLoveNote(),
                                              AntIcons.heartFilled, Colors.red);
                                        },
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            snapshot.data!.trackName,
                                            style: const TextStyle(
                                                fontSize: 22,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                              width: 150,
                                              child: Text(
                                                snapshot.data!.albumName,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    color: Colors.white
                                                        .withOpacity(0.8)),
                                              )),
                                          SizedBox(
                                              width: 150,
                                              child: Text(
                                                snapshot.data!.artists
                                                    .join(", "),
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white
                                                        .withOpacity(0.5)),
                                              ))
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          AntIcons.smileFilled,
                                          color: Colors.amber,
                                        ),
                                        onPressed: () {
                                          showSnackbar(
                                              context,
                                              getGreeting(),
                                              AntIcons.smileFilled,
                                              Colors.amber);
                                        },
                                      )
                                    ],
                                  ))),
                          const SizedBox(
                            height: 25,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: SizedBox(
                                  width: 200,
                                  height: 70,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(AntIcons.paperClipOutlined,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            size: 50),
                                        onPressed: () => setState(() {
                                          _launched =
                                              loadUrl(snapshot.data!.trackUrl);
                                        }),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(AntIcons.playSquareOutlined,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            size: 50),
                                        onPressed: () => setState(() {
                                          _launched =
                                              loadUrl(snapshot.data!.trackUri);
                                        }),
                                      )
                                    ],
                                  ))),
                          const SizedBox(
                            height: 80,
                          ),
                          SizedBox(
                              width: 400,
                              child: Divider(
                                thickness: 1,
                                color: Colors.white.withOpacity(0.8),
                              )),
                          const SizedBox(
                            width: 400,
                            child: PastSongs(),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                  future: song),
            ))));
  }
}

class PastSongs extends StatefulWidget {
  const PastSongs({
    Key? key,
  }) : super(key: key);

  @override
  _PastSongsState createState() => _PastSongsState();
}

class _PastSongsState extends State<PastSongs> {
  late Future<List<Song>> songList;
  Future<void>? _launched;

  @override
  void initState() {
    super.initState();
    songList = getPastSongs("https://sotd.jai.cafe/past_songs");
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    return SizedBox(
        height: 300,
        child: Column(
          children: [
            SizedBox(
                height: 30,
                child:
                    TextButton(onPressed: () {}, child: const Text("Today"))),
            const SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    "Past songs",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
            Divider(thickness: 1, color: Colors.white.withOpacity(0.8)),
            Expanded(
                child: FutureBuilder<List<Song>>(
              future: songList,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Song song = snapshot.data![index];
                        return ListTile(
                            title: Text(
                              song.trackName,
                              style: const TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: Image(
                                image: NetworkImage(
                                    snapshot.data![index].imageUrl)),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snapshot.data![index].albumName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    snapshot.data![index].artists.join(", "),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white.withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ]),
                            onTap: () => setState(() {
                                  _launched =
                                      loadUrl(snapshot.data![index].trackUri);
                                }));
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}",
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white));
                } else {
                  return const CircularProgressIndicator();
                }
              }),
            ))
          ],
        ));
  }
}

String getGreeting() {
  final names = [
    "Anu",
    "Coco",
    "Anubhuti",
    "Anubhuti Agarwal",
    "Maharani Coco",
    "Jaanu",
    "Jojo's lover",
    "Lover of Jai",
    "Soda",
    "Soda Screamer"
  ];
  return "Hu ${names[rng.nextInt(names.length)]}";
}

String getLoveNote() {
  final notes = [
    "I love you",
    "I adore you",
    "You are the love of my life",
    "I miss you",
    "Love you to the moon and back"
  ];
  return "${notes[rng.nextInt(notes.length)]} Anu";
}

Future<LinearGradient> getGradientFromImage(String url) async {
  final response = await http.get(Uri.parse(url));
  assert(response.statusCode == 200);
  final responseBytes = response.bodyBytes;
  final decoder = img.JpegDecoder();
  final decodedImg = decoder.decode(responseBytes);
  final imgBytes = decodedImg?.getBytes(order: img.ChannelOrder.rgb);

  var avgR = 0;
  var avgG = 0;
  var avgB = 0;
  var count = 0;

  for (var i = 0; i < imgBytes!.length / 3; i += 3) {
    var r = imgBytes[i];
    var g = imgBytes[i + 1];
    var b = imgBytes[i + 2];

    avgR += r;
    avgG += g;
    avgB += b;
    count++;
  }

  avgR = (avgR / count).floor();
  avgG = (avgG / count).floor();
  avgB = (avgB / count).floor();

  return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(0xff, avgR, avgG, avgB),
        const Color(0xff000000)
      ]);
}
