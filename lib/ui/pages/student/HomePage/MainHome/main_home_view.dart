import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/courses_tab_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/home_tab/home_tab_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/notifications_tab/notifications_tab_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/profile_tab_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/search_tab/search_tab_view.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

import 'main_home_view_model.dart';

class MainUI extends StatelessWidget {
  bool isParent;
  MainUI({this.isParent = false});
  @override
  Widget build(BuildContext context) {
    print(SizeConfig.heightMultiplier * 100);
    print('is protrait mobile : ${SizeConfig.isMobilePortrait}');
    print('is protrait  : ${SizeConfig.isPortrait}');

    return ChangeNotifierProvider<MainUIVM>(
      create: (context) => MainUIVM(),
      builder: (context, child) => Scaffold(
        bottomNavigationBar: BottomNavigationView(),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                physics: BouncingScrollPhysics(),
                controller:
                    Provider.of<MainUIVM>(context, listen: false).controller,
                onPageChanged: (int index) {
                  Provider.of<MainUIVM>(context, listen: false).onSwipe(index);
                },
                // key: UniqueKey(),
                children: [
                  HomeTabPage(),
                  SearchTabPage(),
                  CoursesTabPage(),
                  NotificationsTabPage(),
                  ProfileTabPage(
                    isParent: isParent,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Consumer<MainUIVM>(builder: (context, model, __) {
      return Container(
        height: SizeConfig.heightMultiplier * 8,
        child: Row(
          // currentIndex: model.currentPage,

          // onTap: model.changePage,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  model.changePage(0);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/home1.svg',
                        height: SizeConfig.heightMultiplier * 2,
                        width: SizeConfig.widthMultiplier * 10,
                        color: model.currentPage == 0
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    ),
                    Text(
                      locale.get('Home'),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: model.currentPage == 0
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  model.changePage(1);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/search.svg',
                        height: SizeConfig.heightMultiplier * 2,
                        width: SizeConfig.widthMultiplier * 10,
                        color: model.currentPage == 1
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    ),
                    Text(
                      locale.get('Search'),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: model.currentPage == 1
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  model.changePage(2);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/Courses.svg',
                        height: SizeConfig.heightMultiplier * 2,
                        width: SizeConfig.widthMultiplier * 10,
                        color: model.currentPage == 2
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    ),
                    Text(
                      locale.get('Courses'),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: model.currentPage == 2
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  model.changePage(3);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/Notifications.svg',
                        height: SizeConfig.heightMultiplier * 2,
                        width: SizeConfig.widthMultiplier * 10,
                        color: model.currentPage == 3
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    ),
                    Text(
                      locale.get('Notifications'),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: model.currentPage == 3
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  model.changePage(4);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/Profile.svg',
                        height: SizeConfig.heightMultiplier * 2,
                        width: SizeConfig.widthMultiplier * 10,
                        color: model.currentPage == 4
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    ),
                    Text(
                      locale.get('Profile'),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: model.currentPage == 4
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
