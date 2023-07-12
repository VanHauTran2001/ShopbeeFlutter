class Users {
  String idUser;
  String name;
  String email;
  String? avatar;
  String phone;
  String passWord;

  Users(
      {required this.idUser,
      required this.name,
      required this.email,
      required this.avatar,
      required this.phone,
      required this.passWord});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        idUser: json['idUser'],
        name: json['name'],
        email: json['email'],
        avatar: json['avatar'],
        phone: json['phone'],
        passWord: json['passWord']);
  }

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'email': email,
        'avatar': avatar,
        'phone': phone,
        'passWord': passWord,
      };

  Users copyWith({String? name, String? phone, String? passWord, String? avatar}) => Users(
      idUser: idUser,
      name: name ?? this.name,
      email: email,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      passWord: passWord ?? this.passWord);
}
