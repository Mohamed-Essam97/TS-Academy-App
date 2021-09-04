import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/review_course_card.dart';
import 'package:ts_academy/ui/styles/colors.dart';

class CourseReviewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoursePageModel>(builder: (context, model, _) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.locale.get("Global Rate"),
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "${model.course.cRating.toStringAsFixed(2)}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 24, color: AppColors.red),
                ),
                RatingBar.builder(
                  initialRating: model.course.cRating.toDouble(),
                  minRating: 4,
                  maxRating: 4,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 25,
                  // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rounded,
                    color: AppColors.rateColorDark,
                  ),
                  unratedColor: Colors.grey[200],
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                Text(
                  "${model.locale.get("With")} ${model.course.reviews.length} ${model.locale.get("Review")}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(height: 1, color: Colors.grey[100]),
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: model.course.reviews.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ReviewCourseCardHorizontal(
                review: model.course.reviews[index],
              ),
              addAutomaticKeepAlives: true,
            ),
          ],
        ),
      );
    });
  }
}
