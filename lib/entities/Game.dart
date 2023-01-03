class Game {
  String Name;
  String ReleaseYear;
  String Developer;
  String Publisher;
  int MaxPlayers;
  String ESRB;
  String OverView;

  Game(this.Name, this.ReleaseYear, this.Developer, this.Publisher, this.MaxPlayers, this.ESRB, this.OverView);

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(json['Name'], json['ReleaseYear'], json['Developer'],
        json['Publisher'], json['MaxPlayers'], json['ESRB'], json['OverView']);
  }
}