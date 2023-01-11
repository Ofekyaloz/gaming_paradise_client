class FullGame {
  int ID;
  String Name;
  int? ReleaseYear;
  String? Developer;
  String? Publisher;
  int MaxPlayers;
  String ESRB;
  String? OverView;
  late List<String> Genres;
  late List<String> Platforms;

  FullGame(this.ID, this.Name, this.ReleaseYear, this.Developer, this.Publisher, this.MaxPlayers, this.ESRB, this.OverView, Genres, Platforms) {
    this.Platforms = [];
    this.Platforms.addAll(List.castFrom(Platforms));

    this.Genres = [];
    this.Genres.addAll(List.castFrom(Genres));


  }

  factory FullGame.fromJson(Map<String, dynamic> json) {
    return FullGame(json['id'], json['Name'], json['ReleaseYear'], json['Developer'],
        json['Publisher'], json['MaxPlayers'], json['ESRB'], json['OverView'],  json['Genres'], json['Platforms']);
  }
}