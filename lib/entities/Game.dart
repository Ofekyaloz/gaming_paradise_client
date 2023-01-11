class Game {
  int ID;
  String Name;
  int? ReleaseYear;
  String? Developer;
  String? Publisher;
  int MaxPlayers;
  String ESRB;
  String? OverView;

  Game(this.ID ,this.Name, this.ReleaseYear, this.Developer, this.Publisher, this.MaxPlayers, this.ESRB, this.OverView);

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(json['id'], json['Name'], json['ReleaseYear'], json['Developer'],
        json['Publisher'], json['MaxPlayers'], json['ESRB'], json['OverView']);
  }
}