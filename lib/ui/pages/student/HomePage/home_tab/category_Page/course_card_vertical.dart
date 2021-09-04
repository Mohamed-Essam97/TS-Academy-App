import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class CourseCardVertical extends StatelessWidget {
  final bool topRated;
  final bool addedRecently;
  Course course;
  CourseCardVertical({
    this.course,
    this.topRated = false,
    this.addedRecently = false,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 30,
                height: SizeConfig.heightMultiplier * 15,
                color: AppColors.primaryColorDark,
                child: CachedNetworkImage(
                  imageUrl: BaseFileUrl + (course.cover ?? ''),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: SizeConfig.widthMultiplier * 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        course.stage.name.localized(context),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        course.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      addedRecently
                          ? Text(
                              "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: AppColors.red),
                            )
                          : Row(
                              children: [
                                RatingBar.builder(
                                  initialRating: course.cRating.toDouble() ?? 5,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,

                                  itemCount: 5,
                                  itemSize: 20,
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
                                  width: 3,
                                ),
                                Text(
                                  course.cRating.toStringAsFixed(1),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text(
                                  course.reviews.length.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${course.price} \$",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      topRated
                          ? Container(
                              decoration:
                                  BoxDecoration(color: AppColors.secondry),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
