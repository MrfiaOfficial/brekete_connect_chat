class UserData {
  String? username;
  String? email;
  String? userId;
  String? img;
  String? timeCreated;
  String? description;
  int? status;
  // List<dynamic>? contact;

  UserData({
    this.username,
    this.email,
    this.userId,
    this.img,
    this.description,
    this.timeCreated,
    this.status,
    // this.contact,
  });

  UserData.fromJson(Map<String?, Object?> json)
      : this(
          username: json['Username']! as String,
          email: json['Email']! as String,
          userId: json['UserId']! as String,
          img: json['img']! as String,
          description: json['Description']! as String,
          timeCreated: json['TimeCreated']! as String,
          status: json['Status']! as int,
        );
  // contact: json['contacts'] as List);

  UserData.fromMap(Map<String?, dynamic> map) {
    // ignore: unnecessary_null_comparison
    this.username = map['Username'];
    this.email = map['Email'];
    this.img = map['img'];
    this.description = map['Description'];
    this.userId = map['UserId'];
    this.status = map['Status'];
    this.timeCreated = map['TimeCreated'];
    // this.contact = map['contacts'];
  }

  Map<String, Object?> toJson() {
    return {
      'Username': username,
      'Email': email,
      'img': img,
      'Description': description,
      'UserId': userId,
      'TimeCreated': timeCreated,
      'Status': status,
      // 'contacts': contact,
    };
  }
}
