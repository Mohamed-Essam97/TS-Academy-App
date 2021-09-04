import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ts_academy/core/models/filter_model.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

import '../../../../routes/ui.dart';
import '../courses_tab/instructor_profile/instructor_profile_view.dart';

class InstractorCard extends StatelessWidget {
  final Instructor instructor;

  InstractorCard({Key key, this.instructor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // ChatService.createChat(
          //     name2: locator<AuthenticationService>().user.name,
          //     userId2: locator<AuthenticationService>().user.sId,
          //     pic2: "auth.user.userInfo.image",
          //     userId1: instructor.user.sId,
          //     name1: instructor.user.name,
          //     pic1: "seller.image");
          // UI.push(
          //     context,
          //     ChatPage(
          //       userId: instructor.user.sId,
          //       userName: instructor.user.name,
          //       userAvatar: "seller.image",
          //     ));
          UI.push(context, InstructorProfilePage(teacherId: instructor.userId));
        },
        child: Container(
          height: SizeConfig.heightMultiplier * 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 40,
                height: SizeConfig.heightMultiplier * 20,
                color: AppColors.primaryColorDark,
                child: CachedNetworkImage(
                  imageUrl: BaseFileUrl + (instructor.avatar ?? ''),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.primaryBackground,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Image.asset('assets/appicon.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                instructor.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingBar.builder(
                    initialRating: instructor.rate?.toDouble() ?? 0.0,
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
                  Text(
                    "${instructor.rate}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
