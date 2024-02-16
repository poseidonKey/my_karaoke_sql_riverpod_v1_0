enum Janre {
  BALLADE,
  DANCE,
  TROT,
  POP,
  CLASSIC,
  ALL,
}

class SongItemModel {
  String? id;
  String songName;
  String songGYNumber;
  String songTJNumber;
  String songJanre;
  String songUtubeAddress;
  String songETC;
  String songCreateTime;
  String songFavorite;

  SongItemModel(
      this.id,
      this.songName,
      this.songGYNumber,
      this.songTJNumber,
      this.songJanre,
      this.songUtubeAddress,
      this.songETC,
      this.songCreateTime,
      this.songFavorite);

  Map<String, dynamic> toMap() {
    return {
      "id": (id == 0) ? null : id,
      "songName": songName,
      "songGYNumber": songGYNumber,
      "songTJNumber": songTJNumber,
      "songJanre": songJanre,
      "songUtubeAddress": songUtubeAddress,
      "songETC": songETC,
      "songCreateTime": songCreateTime,
      "songFavorite": songFavorite,
    };
  }

  SongItemModel copyWith({
    String? id,
    String? songName,
    String? songGYNumber,
    String? songTJNumber,
    String? songJanre,
    String? songUtubeAddress,
    String? songETC,
    String? songCreateTime,
    String? songFavorite,
  }) {
    return SongItemModel(
      id ?? this.id,
      songName ?? this.songName,
      songGYNumber ?? this.songGYNumber,
      songTJNumber ?? this.songTJNumber,
      songJanre ?? this.songJanre,
      songUtubeAddress ?? this.songUtubeAddress,
      songETC ?? this.songETC,
      songCreateTime ?? this.songCreateTime,
      songFavorite ?? this.songFavorite,
    );
  }
}
