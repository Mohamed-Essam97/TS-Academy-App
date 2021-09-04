import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/review_course_card.dart';
import 'package:ts_academy/ui/pages/teacher/add_courses/add_course/add_course_data.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_home/teacher_home_view_model.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

import '../../../styles/size_config.dart';

enum TeacherStatState { NONE, Increase, decrease }

class TeacherHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<TeacherHomePageModel>(
        create: (context) => TeacherHomePageModel(),
        child: Consumer<TeacherHomePageModel>(builder: (context, model, __) {
          return SafeArea(
            child: Scaffold(
              body: model.teacherHomeModel == null
                  ? Center(child: Loading())
                  : Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            greeting(locale, context),
                            createCourseCard(context, locale),
                            model.teacherHomeModel.todayCourses.length > 0
                                ? titleWidget(locale.get('Today Courses'))
                                : SizedBox(),
                            Container(
                              height: SizeConfig.heightMultiplier * 10,
                              margin: EdgeInsets.only(left: 20),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    todayCoursesWidget(
                                        model.teacherHomeModel
                                            .todayCourses[index],
                                        context),
                                itemCount:
                                    model.teacherHomeModel.todayCourses.length,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 2,
                            ),
                            titleWidget(locale.get('Your Statistics')),
                            RatingBar.builder(
                                initialRating:
                                    model.teacherHomeModel.rate.toDouble(),
                                minRating: 4,
                                maxRating: 4,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 50,
                                ignoreGestures: true,
                                // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => Icon(
                                      Icons.star_rounded,
                                      color: AppColors.primaryColor,
                                    ),
                                unratedColor: Colors.grey[200],
                                onRatingUpdate: (rating) {
                                  print(rating);
                                }),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 2,
                            ),
                            Container(
                              height: SizeConfig.heightMultiplier * 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    statisticsInfo(
                                        text: locale.get('Course'),
                                        number: model
                                            .teacherHomeModel.noOfCourses
                                            .toString(),
                                        stat: TeacherStatState.NONE),
                                    statisticsInfo(
                                        text: locale.get('Student'),
                                        number: model
                                            .teacherHomeModel.noOfStudents
                                            .toString(),
                                        stat: TeacherStatState.Increase),
                                    statisticsInfo(
                                        text: locale.get('Rate'),
                                        number: model.teacherHomeModel.rate
                                            .toInt()
                                            .toString(),
                                        stat: TeacherStatState.decrease),
                                  ],
                                ),
                              ),
                            ),
                            titleWidget(locale.get('Latest Feedback')),
                            Container(
                              height: SizeConfig.heightMultiplier * 14,
                              margin: EdgeInsets.only(left: 20),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Container(
                                    width: SizeConfig.widthMultiplier * 60,
                                    child: ReviewCourseCardHorizontal(
                                      review: model.teacherHomeModel
                                          .latestFeedback[index],
                                      isFromHome: true,
                                    )),
                                itemCount: model
                                    .teacherHomeModel.latestFeedback.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        }));
  }
}

Expanded statisticsInfo({String text, String number, TeacherStatState stat}) {
  return Expanded(
      child: Container(
    child: Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                number.toString(),
                style: TextStyle(
                    color: Color(0xffCC1C60),
                    fontSize: SizeConfig.textMultiplier * 2.5,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 2.2,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  ));
}

Container todayCoursesWidget(Course course, context) {
  final locale = AppLocalizations.of(context);
  return Container(
    width: SizeConfig.widthMultiplier * 70,
    height: SizeConfig.heightMultiplier * 20,
    child: Row(
      children: [
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xffCC1C60)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      course.hour.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 2.2),
                    ),
                  ],
                ))),
        Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      UI.push(context,
                          CoursePage(courseId: course.sId, isMyCourse: true));
                    },
                    child: Container(
                      width: double.infinity,
                      child: Text(
                          course.name +
                              "- ${course.subject.name.localized(context)}",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 2)),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                        "${course.grade.name.localized(context)}-${course.stage.name.localized(context)}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: SizeConfig.textMultiplier * 1.8)),
                  ),
                  Container(
                      width: double.infinity,
                      child: Text(
                        locale.get('Send Notification'),
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: SizeConfig.textMultiplier * 2),
                      ))
                ],
              ),
            ))
      ],
    ),
  );
}

Widget titleWidget(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Container(
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(
            fontSize: SizeConfig.textMultiplier * 2.4,
            fontWeight: FontWeight.w700),
      ),
    ),
  );
}

Padding createCourseCard(BuildContext context, locale) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: SizeConfig.heightMultiplier * 18,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.heightMultiplier * 1)),
          gradient: LinearGradient(
              colors: locale.locale.languageCode == 'en'
                  ? [Colors.red, Colors.blue]
                  : [Colors.blue, Colors.red])),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.get('Jump into course creation'),
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 3.2,
                  color: Colors.white),
            ),
            Align(
              alignment: locale.locale.languageCode == 'en'
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCourseData(),
                        ));
                  },
                  child: Text(locale.get('Create your Course'))),
            )
          ],
        ),
      ),
    ),
  );
}

Container greeting(locale, context) {
  final locale = AppLocalizations.of(context);
  return Container(
    height: SizeConfig.heightMultiplier * 12,
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${locale.get('Welcome')} ${locator<AuthenticationService>().user.name}',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  DateTime.now().toString().substring(0, 11),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: CachedNetworkImage(
              imageUrl: BaseFileUrl +
                  (locator<AuthenticationService>().user.avatar ?? ''),
              imageBuilder: (context, imageProvider) => Container(
                    // width: SizeConfig.widthMultiplier * 20,
                    // height: SizeConfig.heightMultiplier * 10,
                    width: SizeConfig.widthMultiplier * 3,
                    // height: SizeConfig.widthMultiplier * 5,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(60),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              placeholder: (context, url) => Loading(),
              errorWidget: (context, url, error) => Container(
                  width: SizeConfig.widthMultiplier * 10,
                  height: SizeConfig.heightMultiplier * 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset('assets/appicon.png'))),
        )
      ],
    ),
  );
}
