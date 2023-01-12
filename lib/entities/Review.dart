class Review {
  int id;
  String? UserName;
  String Content;
  String TimestampCreated;


  Review(this.id, this.UserName, this.Content, this.TimestampCreated);

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        json['id'],  json['UserName'],json['Content'], json['TimestampCreated']);
  }
}
