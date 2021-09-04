import 'dart:io';
import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/models/grade_model.dart';
import 'package:ts_academy/core/models/subject.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/teacher/add_courses/add_section/add_section.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/src/multipart_file.dart';
import 'package:flutter/material.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class AddCourseDataModel extends BaseNotifier {
  BuildContext context;
  FormGroup form;
  Course course;
  AddCourseDataModel({this.context, this.course}) {
    form = FormGroup(
      {
        'subject': FormControl(
          value: course == null ? null : course.subject.sId,
          validators: [
            Validators.required,
          ],
        ),
        'name': FormControl(
          value: course == null ? null : course.name,
          validators: [
            Validators.required,
          ],
        ),
        'cover': FormControl(
          value: course == null ? null : course.cover,
          validators: [
            Validators.required,
          ],
        ),
        'info': FormControl(
          value: course == null ? null : course.info,
          validators: [
            Validators.required,
          ],
        ),
        'description': FormControl(
          value: course == null ? null : course.description,
          validators: [
            Validators.required,
          ],
        ),
        'price': FormControl<int>(
          value: course == null ? null : course.price,
          validators: [
            Validators.required,
          ],
        ),
        'stage': FormControl(
          value: course == null ? null : course.stage.sId,
          validators: [
            Validators.required,
          ],
        ),
        'grade': FormControl(
          value: course == null ? null : course.grade.sId,
          validators: [
            Validators.required,
          ],
        ),
        'Days': FormArray<String>([], validators: [Validators.required]),
        'startDate': FormControl<int>(
          validators: [Validators.required],
          value: course == null
              ? int.parse(DateTime.now().millisecondsSinceEpoch.toString())
              : course.startDate,
        ),
        'teacher':
            FormControl(value: locator<AuthenticationService>().user.sId),
        'hour': FormControl<double>(
          value: course == null ? null : course.hour.toDouble(),
          validators: [
            Validators.required,
          ],
        ),
      },
    );
    if (course != null) {
      // form.patchValue(course.toJson());
      // selectedSteps.addAll(course.days);
    }

    getGrades(context);
    getStages(context);
    getSubject(context);
  }
  FormArray<String> get selectedSteps => form.control('Days') as FormArray;
  List<Stage> stages = [];
  List<Grade> grades = [];
  List<Subject> subjects = [];
  void getStages(context) async {
    setBusy();
    var res = await api.getAllStages(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      stages = data.map<Stage>((item) => Stage.fromJson(item)).toList();
      setIdle();
    });
  }

  void getGrades(context) async {
    setBusy();
    var res = await api.getAllGrades(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      grades = data.map<Grade>((item) => Grade.fromJson(item)).toList();
      setIdle();
    });
  }

  void getSubject(context) async {
    setBusy();
    var res = await api.getAllSubjects(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      subjects = data.map<Subject>((item) => Subject.fromJson(item)).toList();
      setIdle();
    });
  }

  String path;

  bool uploading = false;

  openGallary(BuildContext context, {bool isGallery = false}) async {
    final locale = AppLocalizations.of(context);

    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: resultList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: locale.get('TS Academy App'),
          allViewTitle: locale.get('All Photos'),
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    List<MultipartFile> uploadedFiles = <MultipartFile>[];
    for (var i = 0; i < resultList.length; i++) {
      ByteData byteData = await resultList[i].getByteData(quality: 5);
      List<int> imageData = byteData.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(imageData);

      uploadedFiles.add(multipartFile);
    }
    setBusy();
    var res = await api.uploadImage(context, image: uploadedFiles[0]);
    res.fold((e) => UI.toast(e.message), (data) async {
      form.control("cover").updateValue(data['id'].toString());

      setIdle();
      setState();
    });
  }

//  chooseFile() async {
//     FilePickerResult result = await FilePicker.platform.pickFiles();

//     if (result != null) {
//       File file = File(result.files.single.path);
//       uploadFile(context, file.path);
//       print(file.path);
//       setState();
//     } else {
//       ErrorDialog().notification(
//         "Please upload your resum and cover letter",
//         Colors.red,
//       );
//     }
//   }

//   uploadFile(BuildContext context, result) async {
//     var res = await api.uploadFile(context, file: result);
//     res.fold((e) => UI.toast(e.message), (data) {
//       // Logger().wtf(data);

//         form.control("cover").value = data["id"];

//     });
//     setState();
//   }

  Course courseObject;
  void createCourse() async {
    var res = await api.createTeacherCourse(context, body: form.value);
    res.fold((error) {
      UI.toast(error.message);
    }, (data) {
      courseObject = Course.fromJson(data);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddSectionPage(
              courseId: data["_id"].toString(),
              // course: courseObject,
            ),
          ));
      // Logger().w(data);
    });
  }

  void updateCourse() async {
    var res = await api.updateTeacherCourse(context,
        body: form.value, id: course.sId);
    res.fold((error) {
      UI.toast(error.message);
    }, (data) {
      courseObject = Course.fromJson(data);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddSectionPage(
              courseId: courseObject.sId,
              course: courseObject,
            ),
          ));
      // Logger().w(data);
    });
  }
}
