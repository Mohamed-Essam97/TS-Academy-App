import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/cached_image.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class CoursehorizontalCard extends StatelessWidget {
  final Course course;
  const CoursehorizontalCard({Key key, this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          UI.push(
              context,
              CoursePage(
                courseId: course.sId,
                isMyCourse: true,
              ));
        },
        child: Container(
          width: SizeConfig.widthMultiplier * 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 30,
                height: SizeConfig.heightMultiplier * 14,
                child: CachedNetworkImage(
                  // height: 110,
                  fit: BoxFit.cover,
                  // width: SizeConfig.widthMultiplier * 30,
                  imageUrl: BaseFileUrl + (course.cover ?? ''),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        course.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        course.grade.name.localized(context) +
                            ' - ' +
                            course.grade.stage.name.localized(context),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        course.info,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '${locale.get("Starts")}: '),
                            TextSpan(
                              text: DateFormat("EEEE").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      course.startDate)),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.red),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      LinearPercentIndicator(
                        width: SizeConfig.widthMultiplier * 50,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 10.0,
                        leading:
                            new Text("${course.progress.toStringAsFixed(0)} %"),
                        percent: course.progress / 100,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: AppColors.indecatorColor,
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
