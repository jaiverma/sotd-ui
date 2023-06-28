import "song.dart";

class SongState {
  static final SongState _instance = SongState._internal();

  late Future<Song> sotd;
  late Future<List<Song>> pastSongs;
  late Song? currentSong;

  factory SongState() {
    return _instance;
  }

  SongState._internal() {
    sotd = getSotd("https://sotd.jai.cafe/get_sotd");
    pastSongs = getPastSongs("https://sotd.jai.cafe/past_songs");
    currentSong = null;
  }
}
