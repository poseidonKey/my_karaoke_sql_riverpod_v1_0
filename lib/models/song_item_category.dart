class SongItemCategory {
  String? id;
  String songJanreCategory;

  SongItemCategory(
    this.id,
    this.songJanreCategory,
  );

  Map<String, dynamic> toMap() {
    return {
      "id": (id == 0) ? null : id,
      "songJanreCategory": songJanreCategory,
    };
  }
}
