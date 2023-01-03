class Post {
  int Id;
  String UserName;
  String TimestampCreated;
  String Title;
  String GameName;
  String Content;

  Post(this.Id, this.UserName, this.Title, this.GameName, this.TimestampCreated,
      this.Content);

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(json['Id'], json['UserName'], json['Title'],
        json['GameName'], json['TimestampCreated'], json['Content']);
  }

  setContext(String str) {
    Content = str;
  }

  setTitle(String str) {
    Title = str;
  }
}
