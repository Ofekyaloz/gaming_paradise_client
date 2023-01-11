class Comment {
  int id;
  int PostId;
  String UserName;
  String Content;
  String TimestampCreated;

  Comment(this.id, this.Content, this.TimestampCreated, this.PostId, this.UserName);

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        json['id'], json['Content'], json['TimestampCreated'], json['PostId'],  json['UserName']);
  }
}
