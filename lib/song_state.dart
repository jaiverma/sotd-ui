import "song.dart";
import 'package:http/http.dart' as http;

class SongState {
  static final SongState _instance = SongState._internal();

  late Future<Song> sotd;
  late Future<List<Song>> pastSongs;
  late Song? currentSong;
  late Future<String> greeting;
  late Future<String> loveNote;

  factory SongState() {
    return _instance;
  }

  SongState._internal() {
    sotd = getSotd("https://sotd.jai.cafe/get_sotd");
    pastSongs = getPastSongs("https://sotd.jai.cafe/past_songs");
    currentSong = null;
    greeting = getSimpleHttpResponse("https://sotd.jai.cafe/note/hi");
    loveNote = getSimpleHttpResponse("https://sotd.jai.cafe/note/love");
  }
}

Future<String> getSimpleHttpResponse(String url) async {
  final response = await http.get(Uri.parse(url));
  assert(response.statusCode == 200);
  return response.body;
}
