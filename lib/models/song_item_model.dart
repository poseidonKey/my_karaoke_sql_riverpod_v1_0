import 'package:cloud_firestore/cloud_firestore.dart';

enum Jenre {
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

  factory SongItemModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SongItemModel(
      snapshot['id'],
      snapshot['songName'],
      snapshot['songGYNumber'],
      snapshot['songTJNumber'],
      snapshot['songJanre'],
      snapshot['songUtubeAddress'],
      snapshot['songETC'],
      snapshot['songCreateTime'],
      snapshot['songFavorite'],
    );
  }

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
      id,
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
