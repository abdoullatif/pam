class UserModel {
  final String id;
  final DateTime createdAt;
  final String description;
  final String name;
  final String avatar;

  UserModel({this.id, this.createdAt, this.description, this.name, this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserModel(
      id: json["idplantation"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      description: json["description"],
      name: json["nom"],
      avatar: json["image"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return this?.createdAt?.toString()?.contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}