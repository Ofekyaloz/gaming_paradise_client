class Post {
  int Id;
  String UserName;
  String TimestampCreated;
  String Title;
  String GameName;
  String Content;

  Post(this.Id, this.TimestampCreated, this.Content, this.Title, this.GameName, this.UserName);

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      json['id'],
      json['TimestampCreated'],
      json['Content'],
      json['Title'],
      json['GameName'],
      json['UserName'],
    );
  }

  setContext(String str) {
    Content = str;
  }

  setTitle(String str) {
    Title = str;
  }
}
