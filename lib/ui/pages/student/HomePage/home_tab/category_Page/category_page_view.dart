import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_academy/core/models/basic_data.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/home_tab/category_Page/filter_page/filter_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

import '../course_widget.dart';
import '../instractor_widget.dart';
import 'category_page_view_model.dart';
import 'course_card_vertical.dart';

class CategoryPage extends StatefulWidget {
  String subjectId;
  Name subjectName;

  CategoryPage({this.subjectId, this.subjectName});
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  final dataKey = new GlobalKey();
  ScrollController _controller = new ScrollController();

  void _goToElement(int index) {
    setState(() {
      _controller.animateTo(
          0, // 100 is the height of container and index of 6th element is 5
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInSine);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<CategoryPageModel>(
        create: (context) =>
            CategoryPageModel(subjectId: widget.subjectId, context: context),
        child: Consumer<CategoryPageModel>(builder: (context, model, __) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.primaryColorDark,
                child: Icon(Icons.arrow_upward_rounded, color: Colors.white),
                onPressed: () => {_goToElement(0)},
              ),
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  widget.subjectName.localized(context),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 20),
                ),
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.black)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        _modalBottomSheetMenu(context, model);
                        // UI.push(context, FilterPage());
                      },
                      child: SvgPicture.asset(
                        "assets/images/Filter.svg",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      locator<AuthenticationService>().userLoged
                          ? UI.push(context, CartPage())
                          : UI.push(context, StudentLoginPage());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/images/Cart.svg",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              // extendBodyBehindAppBar: true,
              body: Container(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    model.filter();
                    model.refreshController.refreshCompleted();
                  },
                  onLoading: () {
                    model.onload(context);
                  },
                  controller: model.refreshController,
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: model.busy ||
                            model.filterData == null ||
                            model.cities == null ||
                            model.stages == null ||
                            model.grades == null ||
                            model.subjects == null
                        ? Center(
                            child: Column(
                            children: [
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 30,
                              ),
                              Container(child: Loading()),
                            ],
                          ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              model.filterData.featuresCourses.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        locale.get("Feature Courses") ??
                                            "Feature Courses",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 18),
                                      ),
                                    )
                                  : SizedBox(),
                              model.filterData.featuresCourses.isNotEmpty
                                  ? coursesTopRatedList(model)
                                  : SizedBox(),
                              model.filterData.topInstructors.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        locale.get("Top instructors") ??
                                            "Top instructors",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 18),
                                      ),
                                    )
                                  : SizedBox(),
                              model.filterData.topInstructors.isNotEmpty
                                  ? topInstructorsList(model)
                                  : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  locale.get("All Courses") ?? "All Courses",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: Colors.black, fontSize: 18),
                                ),
                              ),
                              allCourses(model)
                            ],
                          ),
                  ),
                ),
              ));
        }));
  }

  void _modalBottomSheetMenu(context, model) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        isScrollControlled: true,
        // enableDrag: true,

        context: context,
        builder: (context) {
          return new Container(
            // height: SizeConfig.heightMultiplier * 100,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: FilterPage(
              model: model,
              ctx: context,
            ),
          );
        });
  }

  Widget coursesTopRatedList(CategoryPageModel model) {
    return Container(
        height: SizeConfig.heightMultiplier * 45,
        child: model.filterData.featuresCourses.isEmpty
            ? SizedBox()
            : ListView.builder(
                itemCount: model.filterData.featuresCourses.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CourseCardHorizontal(
                    topRated: true,
                    course: model.filterData.featuresCourses[index],
                  );
                }));
  }

  Widget topInstructorsList(CategoryPageModel model) {
    return Container(
        height: SizeConfig.heightMultiplier * 30,
        child: model.filterData.topInstructors.isEmpty
            ? SizedBox()
            : ListView.builder(
                itemCount: model.filterData.topInstructors.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InstractorCard(
                    instructor: model.filterData.topInstructors[index],
                  );
                }));
  }

  Widget allCourses(CategoryPageModel model) {
    final locale = AppLocalizations.of(context);
    return Container(
      child: model.filterData.allCourses.isEmpty
          ? Center(
              child: Text(
              locale.get('No Data Found, try another search'),
            ))
          : ListView.builder(
              itemCount: model.filterData.allCourses.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CourseCardVertical(
                  course: model.filterData.allCourses[index],
                );
              }),
    );
  }
}
