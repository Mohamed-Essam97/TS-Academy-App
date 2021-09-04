import 'package:ts_academy/core/models/basic_data.dart';

class Settings {
  String phoneNumber;
  String whatsapp;
  String instagram;
  String snapchat;
  String twitter;
  String facebook;
  Name about;
  Name terms;
  Name privacy;

  Settings(
      {this.phoneNumber,
      this.whatsapp,
      this.instagram,
      this.snapchat,
      this.twitter,
      this.facebook,
      this.about,
      this.terms,
      this.privacy});

  Settings.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    whatsapp = json['whatsapp'];
    instagram = json['instagram'];
    snapchat = json['snapchat'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    about = json['about'] != null ? new Name.fromJson(json['about']) : null;
    terms = json['terms'] != null ? new Name.fromJson(json['terms']) : null;
    privacy =
        json['privacy'] != null ? new Name.fromJson(json['privacy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['whatsapp'] = this.whatsapp;
    data['instagram'] = this.instagram;
    data['snapchat'] = this.snapchat;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    if (this.about != null) {
      data['about'] = this.about.toJson();
    }
    if (this.terms != null) {
      data['terms'] = this.terms.toJson();
    }
    if (this.privacy != null) {
      data['privacy'] = this.privacy.toJson();
    }
    return data;
  }
}
