import 'package:cloud_firestore/cloud_firestore.dart';

class SongItemCategory {
  String? id;
  String songJanreCategory;

  SongItemCategory(
    this.id,
    this.songJanreCategory,
  );
  factory SongItemCategory.fromSnapshot(DocumentSnapshot snapshot) {
    return SongItemCategory(
      snapshot['id'],
      snapshot['songJanreCategory'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": (id == 0) ? null : id,
      "songJanreCategory": songJanreCategory,
    };
  }
}
