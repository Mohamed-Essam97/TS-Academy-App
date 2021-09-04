// import 'basic_data.dart';

// class StudentBanners {
//   String sId;
//   Name title;
//   int priority;
//   String image;
//   int iV;

//   StudentBanners({this.sId, this.title, this.priority, this.image, this.iV});

//   StudentBanners.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     title = json['title'] != null ? new Name.fromJson(json['title']) : null;
//     priority = json['priority'];
//     image = json['image'];
//     iV = json['__v'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     if (this.title != null) {
//       data['title'] = this.title.toJson();
//     }
//     data['priority'] = this.priority;
//     data['image'] = this.image;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
