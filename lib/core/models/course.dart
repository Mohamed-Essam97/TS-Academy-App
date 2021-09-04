import 'package:ts_academy/core/models/review.dart';
import 'package:ts_academy/core/models/student_model.dart';
import 'package:ts_academy/core/models/subject.dart';
import 'package:ts_academy/core/models/user_model.dart';

class Course {
  List<User> students;
  List<Course> related;
  int enrolled;
  dynamic progress;
  dynamic cRating;
  List<Review> reviews;
  List<Content> content;
  List<String> days;
  String sId;
  String name;
  String info;
  int price;
  String description;
  String cover;
  int startDate;
  Stage stage;
  Grade grade;
  Subject subject;
  dynamic hour;
  User teacher;
  bool inCart;
  bool purchased;
  int createdAt;

  Course(
      {this.students,
      this.related,
      this.enrolled,
      this.progress,
      this.cRating,
      this.reviews,
      this.content,
      this.days,
      this.sId,
      this.name,
      this.info,
      this.price,
      this.description,
      this.cover,
      this.startDate,
      this.stage,
      this.grade,
      this.subject,
      this.hour,
      this.inCart,
      this.createdAt,
      this.purchased,
      this.teacher});

  Course.fromJson(Map<String, dynamic> json) {
    if (json['students'] != null) {
      students = <User>[];
      json['students'].forEach((v) {
        students.add(new User.fromJson(v));
      });
    }
    if (json['related'] != null) {
      related = <Course>[];
      json['related'].forEach((v) {
        related.add(
            v is String ? new Course.fromString(v) : new Course.fromJson(v));
      });
    }
    enrolled = json['enrolled'];
    createdAt = json['createdAt'];
    progress = json['progress'];
    inCart = json['inCart'] == null ? false : json['inCart'];
    purchased = json['purchased'] == null ? false : json['purchased'];
    cRating = json['cRating'];
    if (json['reviews'] != null) {
      reviews = <Review>[];
      json['reviews'].forEach((v) {
        reviews.add(new Review.fromJson(v));
      });
    }
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content.add(new Content.fromJson(v));
      });
    }
    days = json['Days'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    info = json['info'];
    price = json['price'];
    description = json['description'];
    cover = json['cover'];
    startDate = json['startDate'];
    stage = json['stage'] != null
        ? (json['stage'] is String
            ? new Stage.fromString(json['stage'])
            : new Stage.fromJson(json['stage']))
        : null;
    grade = json['grade'] != null
        ? (json['grade'] is String
            ? new Grade.fromString(json['grade'])
            : new Grade.fromJson(json['grade']))
        : null;
    subject = json['subject'] != null
        ? (json['subject'] is String
            ? new Subject.fromString(json['subject'])
            : new Subject.fromJson(json['subject']))
        : null;
    hour = json['hour'];
    teacher = json['teacher'] != null
        ? (json['teacher'] is String
            ? new User.fromString(json['teacher'])
            : new User.fromJson(json['teacher']))
        : null;
  }
  Course.fromString(String id) {
    sId = id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.students != null) {
      data['students'] = this.students.map((v) => v.toJson()).toList();
    }
    if (this.related != null) {
      data['related'] = this.related.map((v) => v.toJson()).toList();
    }
    data['enrolled'] = this.enrolled;
    data['createdAt'] = this.createdAt;
    data['inCart'] = this.inCart;
    data['purchased'] = this.purchased;
    data['progress'] = this.progress;
    data['cRating'] = this.cRating;
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    if (this.content != null) {
      data['content'] = this.content.map((v) => v.toJson()).toList();
    }
    data['Days'] = this.days;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['info'] = this.info;
    data['price'] = this.price;
    data['description'] = this.description;
    data['cover'] = this.cover;
    data['startDate'] = this.startDate;
    if (this.stage != null) {
      data['stage'] = this.stage.toJson();
    }
    if (this.grade != null) {
      data['grade'] = this.grade.toJson();
    }
    if (this.subject != null) {
      data['subject'] = this.subject.toJson();
    }
    data['hour'] = this.hour;
    if (this.teacher != null) {
      data['teacher'] = this.teacher.toJson();
    }

    return data;
  }
}

class Content {
  String chapter;
  List<Lessons> lessons;
  String oId;

  Content({this.chapter, this.lessons, this.oId});

  Content.fromJson(Map<String, dynamic> json) {
    chapter = json['chapter'];
    if (json['lessons'] != null) {
      lessons = new List<Lessons>();
      json['lessons'].forEach((v) {
        lessons.add(new Lessons.fromJson(v));
      });
    }
    oId = json['OId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapter'] = this.chapter;
    if (this.lessons != null) {
      data['lessons'] = this.lessons.map((v) => v.toJson()).toList();
    }
    data['OId'] = this.oId;
    return data;
  }
}

class Lessons {
  String name;
  String type;
  Attachement attachement;
  String oId;
  int uId;
  bool isDone;
  List<Exersices> exersices;

  Lessons(
      {this.name,
      this.type,
      this.attachement,
      this.oId,
      this.uId,
      this.isDone,
      this.exersices});

  Lessons.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    attachement = json['attachement'] != null
        ? new Attachement.fromJson(json['attachement'])
        : null;
    oId = json['OId'];
    uId = json['uId'];
    isDone = json['isDone'];
    if (json['exersices'] != null) {
      exersices = new List<Exersices>();
      json['exersices'].forEach((v) {
        exersices.add(new Exersices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.attachement != null) {
      data['attachement'] = this.attachement.toJson();
    }
    data['OId'] = this.oId;
    data['uId'] = this.uId;
    data['isDone'] = this.isDone;
    if (this.exersices != null) {
      data['exersices'] = this.exersices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachement {
  String id;
  String path;
  String name;
  String mimetype;

  Attachement({this.id, this.path, this.name, this.mimetype});

  Attachement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    name = json['name'];
    mimetype = json['mimetype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['path'] = this.path;
    data['name'] = this.name;
    data['mimetype'] = this.mimetype;
    return data;
  }
}

class Exersices {
  String oId;
  User user;
  String link;

  Exersices({this.oId, this.user, this.link});

  Exersices.fromJson(Map<String, dynamic> json) {
    oId = json['oId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oId'] = this.oId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.link != null) {
      data['link'] = this.link;
    }
    return data;
  }
}
