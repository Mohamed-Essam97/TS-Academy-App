import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';
import 'package:ts_academy/ui/widgets/expanded_lessons.dart';

class CourseLessonsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoursePageModel>(builder: (context, model, _) {
      return Scaffold(
        body: Container(
          child: ListView.separated(
              itemCount: model.course.content.length,
              padding: EdgeInsets.zero,
              // physics: const NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) => ExpandedLessons(
                  content: model.course.content[index],
                  course: model.course,
                  model: model)),
        ),
      );
    });
  }
}
