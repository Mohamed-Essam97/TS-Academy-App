import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/search_tab/search_tab_view.dart';
import 'package:ts_academy/ui/routes/route.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'category_Page/category_page_view.dart';
import 'course_widget.dart';
import 'home_tab_view_model.dart';
import 'instractor_widget.dart';

class HomeTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return ChangeNotifierProvider<HomeTabPageModel>(
        create: (context) => HomeTabPageModel(context: context),
        child: Consumer<HomeTabPageModel>(builder: (context, model, __) {
          return Scaffold(
              body: SingleChildScrollView(
            child: model.busy
                ? Container(
                    height: SizeConfig.heightMultiplier * 100,
                    width: SizeConfig.widthMultiplier * 100,
                    child: Center(child: Loading()))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerWidget(context, locale, model),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          locale.get("Featured") ?? "Featured",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      featuresCoursesList(true, model),
                      model.homeModel.startSoon.length > 0
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                locale.get("Start Soon") ?? "Start Soon",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Colors.black, fontSize: 20),
                              ),
                            )
                          : SizedBox(),
                      model.homeModel.startSoon.length > 0
                          ? startSoonCoursesList(false, model)
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              locale.get("Subjects") ?? "Subjects",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.black, fontSize: 20),
                            ),
                            InkWell(
                              onTap: () {
                                UI.push(context, SearchTabPage());
                              },
                              child: Text(
                                locale.get("See All") ?? "See All",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.blueGrey,
                                      fontSize: 15,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      categoriesList(context, model),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          locale.get("Top instructors") ?? "Top instructors",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      model.homeModel.topInstructors == null
                          ? SizedBox()
                          : instractorList(model),
                      model.homeModel.partners.length > 0
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                locale.get("Our partners") ?? "Our partners",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Colors.black, fontSize: 20),
                              ),
                            )
                          : SizedBox(),
                      model.homeModel.partners.length > 0
                          ? partnersList(model)
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          locale.get("Added recently") ?? "Added recently",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      addedRecentkyList(model),
                    ],
                  ),
          ));
        }));
  }

  Widget featuresCoursesList(bool topRated, HomeTabPageModel model) {
    return Container(
        height: SizeConfig.heightMultiplier * 45,
        child: ListView.builder(
            itemCount: model.homeModel.featuresCourses.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return CourseCardHorizontal(
                course: model.homeModel.featuresCourses[index],
                topRated: topRated,
              );
            }));
  }

  Widget startSoonCoursesList(bool topRated, HomeTabPageModel model) {
    return Container(
        height: SizeConfig.heightMultiplier * 45,
        child: ListView.builder(
            itemCount: model.homeModel.startSoon.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return CourseCardHorizontal(
                course: model.homeModel.startSoon[index],
                topRated: topRated,
              );
            }));
  }

  Widget addedRecentkyList(HomeTabPageModel model) {
    return Container(
        height: SizeConfig.heightMultiplier * 45,
        child: ListView.builder(
            itemCount: model.homeModel.addedRecently.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return CourseCardHorizontal(
                addedRecently: true,
                course: model.homeModel.addedRecently[index],
              );
            }));
  }

  Widget instractorList(HomeTabPageModel model) {
    return Container(
        height: SizeConfig.heightMultiplier * 30,
        child: ListView.builder(
            itemCount: model.homeModel.topInstructors.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InstractorCard(
                instructor: model.homeModel.topInstructors[index],
              );
            }));
  }

  Widget categoriesList(context, HomeTabPageModel model) {
    // var _aspectRatio = _width / cellHeight;
    return Container(
        height: SizeConfig.heightMultiplier * 15,
        child: GridView.builder(
            itemCount: model.homeModel.subjects.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
                childAspectRatio: 1 / 2),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    UI.push(
                        context,
                        CategoryPage(
                          subjectId: model.homeModel.subjects[index].sId,
                          subjectName: model.homeModel.subjects[index].name,
                        ));
                  },
                  child: Container(
                    width: SizeConfig.widthMultiplier * 40,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              "${model.api.imagePath}${model.homeModel.subjects[index].image}",
                          imageBuilder: (context, imageProvider) => Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black54, BlendMode.color)),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Text(
                          model.homeModel.subjects[index].name
                                  .localized(context)
                                  .substring(0, 10) ??
                              "",
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  Widget _headerWidget(context, locale, HomeTabPageModel model) {
    return model.busy
        ? Loading()
        : Stack(
            children: [
              Container(
                  height: SizeConfig.heightMultiplier * 40,
                  child: ListView.builder(
                    itemCount: model.homeModel.banners.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Stack(
                      children: [
                        Container(
                          width: SizeConfig.widthMultiplier * 100,
                          height: SizeConfig.heightMultiplier * 40,
                          // color: AppColors.primaryColorDark,
                          child: CachedNetworkImage(
                            imageUrl:
                                "${model.api.imagePath}${model.homeModel.banners[index].image}",
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                        Colors.black54, BlendMode.color)),
                              ),
                            ),
                            placeholder: (context, url) => Loading(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Positioned(
                            left: 20,
                            bottom: 20,
                            child: Container(
                              width: SizeConfig.widthMultiplier * 60,
                              child: Text(
                                  model.homeModel.banners[index].title
                                      .localized(context),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: Colors.white, fontSize: 20)),
                            ))
                      ],
                    ),
                  )),
              Positioned(
                right: 20,
                top: 30,
                child: InkWell(
                  onTap: () {
                    locator<AuthenticationService>().userLoged
                        ? UI.push(context, CartPage())
                        : UI.push(context, StudentLoginPage());
                  },
                  child: SvgPicture.asset(
                    "assets/images/Cart.svg",
                    color: Colors.white,
                    width: 25,
                  ),
                ),
              ),
            ],
          );
  }

  Widget partnersList(HomeTabPageModel model) {
    return Container(
        height: SizeConfig.heightMultiplier * 15,
        child: ListView.builder(
            itemCount: model.homeModel.partners.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: SizeConfig.widthMultiplier * 20,
                  height: SizeConfig.widthMultiplier * 20,
                  child: CachedNetworkImage(
                    imageUrl:
                        "${model.api.imagePath}${model.homeModel.partners[index].logo}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        // color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Colors.grey.shade100, Colors.blueAccent],
                            stops: [1, 50]),
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center),
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
              );
            }));
  }
}
