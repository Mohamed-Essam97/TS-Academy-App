import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating_pullup_card/floating_layout.dart';
import 'package:floating_pullup_card/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/review_tab.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/custom/add-review.widget.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'info_tab.dart';
import 'lessons_tab.dart';
import 'students_tab.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';

class CoursePage extends StatefulWidget {
  final String courseId;
  final bool isMyCourse;

  CoursePage({this.courseId, this.isMyCourse = false});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    if (locator<AuthenticationService>().userLoged &&
        locator<AuthenticationService>().user?.userType == "Teacher")
      _tabController = new TabController(length: 4, vsync: this);
    else
      _tabController = new TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<CoursePageModel>(
        create: (context) => CoursePageModel(context, locale, _tabController,
            courseId: widget.courseId, isMyCourse: widget.isMyCourse),
        child: Consumer<CoursePageModel>(builder: (context, model, __) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              actions: [
                locator<AuthenticationService>().userLoged &&
                        locator<AuthenticationService>().user?.userType ==
                            "Teacher"
                    ? SizedBox()
                    : IconButton(
                        // padding: const EdgeInsets.all(8.0),
                        icon: SvgPicture.asset(
                          "assets/images/Cart.svg",
                          color: Colors.white,
                        ),
                        onPressed: () {
                          UI.push(context, CartPage());
                        },
                      ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            extendBodyBehindAppBar: true,
            floatingActionButton: model.course != null &&
                    model.course.purchased &&
                    locator<AuthenticationService>().userLoged &&
                    locator<AuthenticationService>().user?.userType !=
                        "Teacher" &&
                    (model.course.reviews.length == 0 ||
                        (locator<AuthenticationService>().userLoged &&
                            model.course.reviews.firstWhere(
                                    (element) =>
                                        element.user?.sId ==
                                        locator<AuthenticationService>()
                                            .user
                                            ?.sId,
                                    orElse: () => null) ==
                                null)) &&
                    model.reviewsTabActive
                ? FloatingActionButton(
                    onPressed: () {
                      UI.dialog(
                        context: context,
                        child: AddReviewWidget(model),
                        // title: locale.get("permission denied"),
                        accept: true,
                        dismissible: true,
                      );
                    },
                    child: const Icon(Icons.rate_review_outlined),
                    backgroundColor: AppColors.primaryColor,
                    splashColor: AppColors.secondaryElement,
                    hoverColor: Colors.grey,
                    tooltip: locale.get('Write a review'),
                  )
                : null,
            body: model.busy
                ? Center(
                    child: PlaceholderLines(
                    count: 10,
                    animate: true,
                    align: TextAlign.center,
                  ))
                : (locator<AuthenticationService>().userLoged &&
                            locator<AuthenticationService>().user?.userType ==
                                "Teacher") ||
                        model.course.purchased
                    ? courseBody(model, locale)
                    : FloatingPullUpCardLayout(
                        autoPadding: false,
                        cardElevation: 10,
                        withOverlay: false,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        width: SizeConfig.widthMultiplier * 90,
                        dismissable: false,
                        cardColor: AppColors.primaryColorDark,
                        onOutsideTap: () {
                          return FloatingPullUpState.collapsed;
                        },
                        child: courseBody(model, locale),
                        body: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: <Widget>[
                              NormalButton(
                                color: Colors.white,
                                textColor: AppColors.primaryColor,
                                localize: true,
                                text: model.course.inCart
                                    ? "${locale.get('Added To Cart')}"
                                    : "${locale.get('Add To Cart')}" +
                                        "/ ${locale.get('Price')} ${model.course.price}",
                                onPressed: () {
                                  !model.course.inCart
                                      ? locator<AuthenticationService>()
                                              .userLoged
                                          ? model.addToCart(model.course?.sId)
                                          : UI.push(context, StudentLoginPage())
                                      : UI.push(context, CartPage());
                                },
                                height: 50,
                              ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       locale.get('Price'),
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .bodyText1
                              //           .copyWith(
                              //               fontSize: 16,
                              //               fontWeight: FontWeight.bold),
                              //     ),
                              //     Text(
                              //       "${model.course.price}",
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .bodyText1
                              //           .copyWith(
                              //               fontSize: 18,
                              //               color: Colors.redAccent,
                              //               fontWeight: FontWeight.w900),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
          );
        }));
  }

  Widget courseBody(model, locale) => Container(
        // decoration: BoxDecoration(color: Colors.purple[100]),
        child: Center(
            child: Column(
          children: [
            Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl:
                      // "https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-lkmqn1nhu0hem3kvtjrkbvr1v2-20180611171604.Medi.jpeg",
                      BaseFileUrl + (model.course.cover ?? ''),
                  imageBuilder: (context, imageProvider) => Container(
                    width: SizeConfig.widthMultiplier * 100,
                    height: SizeConfig.heightMultiplier * 30,
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
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Text(
                    // "The complete course to learn math essential."
                    "${model.course.name}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white, fontSize: 15),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: Container(
                    // width: SizeConfig.widthMultiplier * 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.get('By') + " " + model.course.teacher.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.white, fontSize: 10),
                        ),
                        RatingBar.builder(
                          initialRating:
                              model.course.teacher.cRating?.toDouble() ??
                                  model.course.cRating.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,

                          itemCount: 5,
                          itemSize: 20,
                          glow: true,
                          ignoreGestures: true,
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
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: TabBar(
                  unselectedLabelColor: Colors.black,
                  indicatorColor: AppColors.primaryColor,
                  indicator: MaterialIndicator(
                    color: AppColors.primaryColor,
                    height: 5,
                    topLeftRadius: 8,
                    topRightRadius: 8,
                    // horizontalPadding: 50,
                    tabPosition: TabPosition.bottom,
                  ),
                  onTap: (value) {
                    if (value == 2)
                      model.reviewsTabActive = true;
                    else
                      model.reviewsTabActive = false;
                    setState(() {});
                    print(value);
                  },
                  labelColor: AppColors.primaryColor,
                  tabs: [
                    Tab(
                      text: locale.get('Info'),
                    ),
                    Tab(
                      text: locale.get('Lessons'),
                    ),
                    Tab(
                      text: locale.get('Reviews'),
                    ),
                    if (locator<AuthenticationService>().userLoged &&
                        locator<AuthenticationService>().user?.userType ==
                            "Teacher")
                      Tab(
                        text: locale.get('Students'),
                      )
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CourseInfoTab(),
                  CourseLessonsTab(),
                  CourseReviewsTab(),
                  if (locator<AuthenticationService>().userLoged &&
                      locator<AuthenticationService>().user?.userType ==
                          "Teacher")
                    CourseStudentsTab()
                ],
                controller: _tabController,
              ),
            )
          ],
        )),
      );
}
