import 'dart:convert';

ChatUser chatUserFromJson(String str) => ChatUser.fromJson(json.decode(str));

String chatUserToJson(ChatUser data) => json.encode(data.toJson());

class ChatUser {
  ChatUser({
    required this.userPass,
    required this.userMail,
    required this.about,
    required this.createdAt,
    required this.userImgUrl,
    required this.username,
    required this.id,
  });

  String? id;
  String? userPass;
  String? userMail;
  String? about;
  String? createdAt;
  String? userImgUrl;
  String? username;

  ChatUser.fromJson(Map<String, dynamic> json) {
    userPass = json["userPass"];
    userMail = json["userMail"];
    about = json["about"];
    createdAt = json["created_at"];
    userImgUrl = json["userImgUrl"];
    username = json["username"];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data["userPass"] = userPass;
    data["userMail"] = userMail;
    data["about"] = about;
    data["created_at"] = createdAt;
    data["userImgUrl"] = userImgUrl;
    data["username"] = username;
    data["id"] = id;

    return data;
  }
}
