import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

import '../../../../../core/models/course.dart';
import 'package:timeago/timeago.dart' as timeago;

class CourseCardHorizontal extends StatelessWidget {
  final bool topRated;
  final bool addedRecently;
  final Course course;
  const CourseCardHorizontal({
    this.topRated = false,
    this.addedRecently = false,
    this.course,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          UI.push(context, CoursePage(courseId: course.sId));
        },
        child: Container(
          width: SizeConfig.widthMultiplier * 55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 55,
                height: SizeConfig.heightMultiplier * 20,
                color: AppColors.primaryColorDark,
                child: CachedNetworkImage(
                    imageUrl: BaseFileUrl + (course.cover ?? ''),
                    // ,
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
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
              ),
              SizedBox(height: 5),
              Text(
                "${course.name ?? ""}",
                // "Flutter 2.2",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 5),
              Text(
                "${course.info ?? ""}",
                // "fdsAA fsdf sd  sdf dsf ds f dsfsdf",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),
              ),
              SizedBox(height: 5),
              // Text(
              //   "${course.description ?? ""}",
              //   // "fdsss fsdf sd  sdf dsf ds f dsfsdf",
              //   overflow: TextOverflow.ellipsis,
              //   style: Theme.of(context).textTheme.bodyText1.copyWith(
              //       fontSize: 12,
              //       fontWeight: FontWeight.normal,
              //       color: Colors.black),
              // ),
              // SizedBox(height: 5),
              addedRecently
                  ? Text(
                      timeago.format(
                          DateTime.fromMillisecondsSinceEpoch(course.createdAt),
                          locale: locale.locale.languageCode),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.blueGrey),
                    )
                  : Row(
                      children: [
                        RatingBar.builder(
                          initialRating: course.cRating.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,

                          itemCount: 5,
                          itemSize: 20,
                          ignoreGestures: true,
                          // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star_rounded,
                            color: AppColors.rateColorDark,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        Text(
                          "(${course.reviews.length ?? ""})",
                          // "5",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
              SizedBox(
                height: 5,
              ),
              Text(
                "${course.price ?? ""} ${locale.get('SR')}",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.red),
              ),
              SizedBox(
                height: 5,
              ),
              topRated
                  ? Container(
                      decoration: BoxDecoration(color: AppColors.secondry),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          locale.get("Top Rated"),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
