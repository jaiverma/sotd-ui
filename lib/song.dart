import 'dart:convert';
import 'package:http/http.dart' as http;

class Song {
  final String albumName;
  final List<dynamic> artists;
  final String imageUrl;
  final String releaseDate;
  final String trackName;
  final String trackUri;
  final String trackUrl;

  Song(this.albumName, this.artists, this.imageUrl, this.releaseDate,
      this.trackName, this.trackUri, this.trackUrl);

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
    throw Exception("Failed to get song of the day :(");
  }
}

Future<List<Song>> getPastSongs(String url) async {
  final resp = await http.get(Uri.parse(url));

  if (resp.statusCode == 200) {
    final data = jsonDecode(resp.body) as List<dynamic>;
    return data.map((e) => Song.fromJson(e)).toList();
  } else {
    throw Exception("Failed to get past songs :(");
  }
}
