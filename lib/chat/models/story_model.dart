class StoryModal {
  String? date;
  String? urls;
  String? postedBy;
  String? content;
  String? type;

  StoryModal({
    this.content,
    this.urls,
    this.date,
    this.postedBy,
    this.type,
  });

  StoryModal.fromJson(Map<String, Object?> json)
      : this(
          postedBy: json['PostedBy']! as String,
          urls: json['Urls']! as String,
          content: json['Content']! as String,
          date: json['Date']! as String,
          type: json['Type']! as String,
        );

  StoryModal.fromMap(Map<String?, dynamic> map) {
    this.postedBy = map['PostedBy'];
    this.urls = map['Urls'];
    this.content = map['Content'];
    this.date = map['Date'];
    this.type = map['Type'];
  }

  Map<String, Object?> toJson() {
    return {
      'PostedBy': postedBy,
      'Content': content,
      'Urls': urls,
      'Date': date,
      'Type': type,
    };
  }
}
