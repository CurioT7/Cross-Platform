class UserSearch {
  String? id;
  String? username;
  int? karma;
  String? profilePicture;

  UserSearch({this.id, this.username, this.karma, this.profilePicture});

  factory UserSearch.fromJson(Map<String, dynamic> json) => UserSearch(
        id: json['_id'] as String?,
        username: json['username'] as String?,
        karma: json['karma'] as int?,
        profilePicture: json['profilePicture'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
        'karma': karma,
        'profilePicture': profilePicture,
      };

  static List<UserSearch> getUsers(List<dynamic> json) {
    return json.map((user) => UserSearch.fromJson(user)).toList();
  }
}
