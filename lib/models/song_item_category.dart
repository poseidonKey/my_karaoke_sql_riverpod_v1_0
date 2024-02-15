class SongItemCategory {
  String? id;
  String songJanreCate;

  SongItemCategory(
    this.id,
    this.songJanreCate,
  );

  Map<String, dynamic> toMap() {
    return {
      "id": (id == 0) ? null : id,
      "songJanreCate": songJanreCate,
    };
  }
}
