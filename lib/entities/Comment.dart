class Comment {
  int CommenteId;
  int PostId;
  String UserName;
  String Content;

  Comment(this.CommenteId, this.PostId, this.UserName, this.Content);

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        json['CommentId'], json['PostId'], json['UserName'], json['Content']);
  }
}
