class UsernameModel{
  String? username;
  String? uuid;

  UsernameModel({this.username, this.uuid});

  Map<String, dynamic> toJson() => {
        'username': username,
        'uuid': uuid
      };
}