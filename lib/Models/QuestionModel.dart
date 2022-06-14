class QuestionModel {
  String? question;
  List<Selections>? selections;

  QuestionModel({this.question, this.selections});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    if (json['selections'] != null) {
      selections = <Selections>[];
      json['selections'].forEach((v) {
        selections!.add(new Selections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    if (this.selections != null) {
      data['selections'] = this.selections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Selections {
  String? id;
  String? name;
  String? nickname;
  String? selectedThumbnail;
  String? unselectedThumbnail;
  String? color;
  int? classId;
  String? className;
  int? sortOrder;

  Selections(
      {this.id,
        this.name,
        this.nickname,
        this.selectedThumbnail,
        this.unselectedThumbnail,
        this.color,
        this.classId,
        this.className,
        this.sortOrder});

  Selections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nickname = json['nickname'];
    selectedThumbnail = json['selected_thumbnail'];
    unselectedThumbnail = json['unselected_thumbnail'];
    color = json['color'];
    classId = json['class_id'];
    className = json['class_name'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['nickname'] = this.nickname;
    data['selected_thumbnail'] = this.selectedThumbnail;
    data['unselected_thumbnail'] = this.unselectedThumbnail;
    data['color'] = this.color;
    data['class_id'] = this.classId;
    data['class_name'] = this.className;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}