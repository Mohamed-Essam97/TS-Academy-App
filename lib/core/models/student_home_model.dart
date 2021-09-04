import 'package:ts_academy/core/models/basic_data.dart';
import 'package:ts_academy/core/models/subject.dart';

import 'course.dart';
import 'filter_model.dart';

class StudentHomeModel {
  List<Banners> banners;
  List<Partners> partners;
  List<Course> featuresCourses;
  List<Course> addedRecently;
  List<Course> startSoon;
  List<Subject> subjects;
  List<Instructor> topInstructors;

  StudentHomeModel(
      {this.banners,
      this.partners,
      this.featuresCourses,
      this.addedRecently,
      this.startSoon,
      this.subjects,
      this.topInstructors});

  StudentHomeModel.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners.add(new Banners.fromJson(v));
      });
    }
    if (json['partners'] != null) {
      partners = <Partners>[];
      json['partners'].forEach((v) {
        partners.add(new Partners.fromJson(v));
      });
    }
    if (json['featuresCourses'] != null) {
      featuresCourses = <Course>[];
      json['featuresCourses'].forEach((v) {
        featuresCourses.add(
            v is String ? new Course.fromString(v) : new Course.fromJson(v));
      });
    }
    if (json['addedRecently'] != null) {
      addedRecently = <Course>[];
      json['addedRecently'].forEach((v) {
        addedRecently.add(
            v is String ? new Course.fromString(v) : new Course.fromJson(v));
      });
    }
    if (json['startSoon'] != null) {
      startSoon = <Course>[];
      json['startSoon'].forEach((v) {
        startSoon.add(
            v is String ? new Course.fromString(v) : new Course.fromJson(v));
      });
    }
    if (json['subjects'] != null) {
      subjects = <Subject>[];
      json['subjects'].forEach((v) {
        subjects.add(
            v is String ? new Subject.fromString(v) : new Subject.fromJson(v));
      });
    }
    if (json['topInstructors'] != null) {
      topInstructors = <Instructor>[];
      json['topInstructors'].forEach((v) {
        topInstructors.add(new Instructor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    if (this.partners != null) {
      data['partners'] = this.partners.map((v) => v.toJson()).toList();
    }
    if (this.featuresCourses != null) {
      data['featuresCourses'] =
          this.featuresCourses.map((v) => v.toJson()).toList();
    }
    if (this.addedRecently != null) {
      data['addedRecently'] =
          this.addedRecently.map((v) => v.toJson()).toList();
    }
    if (this.startSoon != null) {
      data['startSoon'] = this.startSoon.map((v) => v.toJson()).toList();
    }
    if (this.subjects != null) {
      data['subjects'] = this.subjects.map((v) => v.toJson()).toList();
    }
    if (this.topInstructors != null) {
      data['topInstructors'] =
          this.topInstructors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banners {
  String sId;
  Name title;
  int priority;
  String image;
  int iV;

  Banners({this.sId, this.title, this.priority, this.image, this.iV});

  Banners.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'] != null ? new Name.fromJson(json['title']) : null;
    priority = json['priority'];
    image = json['image'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    data['priority'] = this.priority;
    data['image'] = this.image;
    data['__v'] = this.iV;
    return data;
  }
}

class Partners {
  String sId;
  String name;
  String logo;
  int iV;

  Partners({this.sId, this.name, this.logo, this.iV});

  Partners.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    logo = json['logo'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['__v'] = this.iV;
    return data;
  }
}
