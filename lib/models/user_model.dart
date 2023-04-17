class UserModel {
  String? name;
  String? email;
  String? uId;
  String? image;
  String? about;

  UserModel({
    this.name,
    this.email,
    this.uId,
    this.image,
    this.about,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    uId = json['uId'];
    image = json['image'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'uId': uId,
      'image': image,
      'about': about,
    };
  }
}
