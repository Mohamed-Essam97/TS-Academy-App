import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/providers/teacher/main_ui_teacher_vm.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/notifications_tab/notifications_tab_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/profile_tab_view.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/start-live.model.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_courses_tab/teacher_courses_view.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_home/teacher_home.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import '../../../styles/colors.dart';
import '../../../styles/size_config.dart';
import 'package:im_stepper/stepper.dart';

class MainUITeacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainUITeacherVM>(
        create: (context) => MainUITeacherVM(),
        builder: (context, child) => Scaffold(
              bottomNavigationBar: Container(child: BottomNavigationView()),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: InkWell(
                onTap: () {
                  showCupertinoModalBottomSheet(
                      context: context,
                      shadow: BoxShadow(blurRadius: 15, color: AppColors.red),
                      topRadius: Radius.circular(25),
                      builder: (context) => Container(
                          height: SizeConfig.heightMultiplier * 30,
                          child: GoLive()),
                      duration: Duration(milliseconds: 600),
                      bounce: true);
                },
                child: Container(
                  height: SizeConfig.heightMultiplier * 15,
                  width: SizeConfig.widthMultiplier * 15,
                  // decoration: BoxDecoration(shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    "assets/images/Live.svg",
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: PageView(
                      physics: BouncingScrollPhysics(),
                      controller:
                          Provider.of<MainUITeacherVM>(context, listen: false)
                              .controller,
                      onPageChanged: (int index) {
                        Provider.of<MainUITeacherVM>(context, listen: false)
                            .onSwipe(index);
                      },
                      key: UniqueKey(),
                      children: [
                        TeacherHome(),
                        TeacherCoursesPage(),
                        NotificationsTabPage(),
                        ProfileTabPage(
                          isParent: false,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}

class GoLive extends StatefulWidget {
  const GoLive({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _GoLive();
}

class _GoLive extends State<GoLive> {
  int activeStep = 1;

  int upperBound = 2;
  AppLocalizations locale;

  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<StartLiveModel>(
      create: (context) => StartLiveModel(context),
      child: Consumer<StartLiveModel>(builder: (context, model, __) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconStepper(
                activeStepBorderColor: AppColors.primaryColor,
                activeStepColor: AppColors.primaryColor,
                lineColor: AppColors.primaryColor,
                alignment: Alignment.topCenter,
                stepRadius: 15,
                activeStepBorderWidth: 1,
                activeStepBorderPadding: 2,
                stepColor: Colors.grey[200],
                enableNextPreviousButtons: false,
                enableStepTapping: false,
                stepReachedAnimationDuration: Duration(seconds: 1),
                stepReachedAnimationEffect: Curves.easeInCubic,

                icons: [
                  // Icon(Icons.camera_enhance_outlined),
                  Icon(
                    Icons.book,
                    color: activeStep == 1 ? Colors.white : Colors.blueGrey,
                    semanticLabel: 'Select Course',
                  ),
                  Icon(Icons.bookmark,
                      color: activeStep == 2 ? Colors.white : Colors.blueGrey,
                      semanticLabel: 'Select Chapter'),
                  Icon(Icons.label,
                      color: activeStep == 3 ? Colors.white : Colors.blueGrey,
                      semanticLabel: 'Select Lesson'),
                ],

                activeStep: activeStep - 1,

                // This ensures step-tapping updates the activeStep.
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                  });
                },
              ),
              header(),
              Expanded(
                child: Center(
                  child: model.busy ? Loading() : body(model),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     activeStep != 1 ? previousButton() : SizedBox(),
              //     activeStep != 3 ? nextButton() : SizedBox(),
              //   ],
              // )
            ],
          ),
        );
      }),
    );
  }

  Widget body(StartLiveModel model) {
    switch (activeStep) {
      case 1:
        return Container(
          alignment: Alignment.center,
          width: SizeConfig.widthMultiplier * 80,
          child: SizedBox(
            width: SizeConfig.widthMultiplier * 75,
            child: DropdownButton<Course>(
              hint: Text(locale.get('Select Course')),
              selectedItemBuilder: (BuildContext context) {
                return model.courses.map((Course item) {
                  return Container(
                    width: SizeConfig.widthMultiplier * 68,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name),
                        Text(
                          "-",
                          style: TextStyle(color: AppColors.red),
                        ),
                        Text(item.grade.name.localized(context)),
                        Text(
                          "-",
                          style: TextStyle(color: AppColors.red),
                        ),
                        Text(item.subject.name.localized(context)),
                      ],
                    ),
                  );
                }).toList();
              },
              dropdownColor: AppColors.accentText,
              iconSize: 24,
              value: model.selectedCourse,
              autofocus: true,
              elevation: 16,
              style: const TextStyle(color: AppColors.primaryColor),
              underline: Container(
                height: 0.5,
                color: AppColors.primaryColor,
              ),
              onChanged: (Course newValue) {
                if (newValue.startDate <
                        DateTime.now().millisecondsSinceEpoch ||
                    newValue.days.firstWhere(
                            (element) =>
                                element ==
                                DateFormat('EEEE').format(DateTime.now()),
                            orElse: () => null) ==
                        null) {
                  UI.showSnackBarMessage(
                      context: context,
                      message: locale.get('This Course Starts At') +
                          " ${DateFormat('d-M-y').format(DateTime.fromMillisecondsSinceEpoch(newValue.startDate))} ${locale.get('in Days')} ${newValue.days.map((e) => locale.get(e)).toString()}");
                } else
                  setState(() {
                    model.selectedCourse = newValue;
                    activeStep++;
                  });
              },
              items:
                  model.courses.map<DropdownMenuItem<Course>>((Course value) {
                return DropdownMenuItem<Course>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
        );
      case 2:
        return Container(
          alignment: Alignment.center,
          width: SizeConfig.widthMultiplier * 80,
          child: SizedBox(
            width: SizeConfig.widthMultiplier * 75,
            child: DropdownButton<Content>(
              hint: Text(locale.get('Select Chapter')),
              selectedItemBuilder: (BuildContext context) {
                return model.selectedCourse.content.map((Content item) {
                  return Container(
                    width: SizeConfig.widthMultiplier * 68,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(item.chapter)],
                    ),
                  );
                }).toList();
              },
              dropdownColor: AppColors.accentText,
              iconSize: 24,
              value: model.selectedChapter,
              autofocus: true,
              elevation: 16,
              style: const TextStyle(color: AppColors.primaryColor),
              underline: Container(
                height: 0.5,
                color: AppColors.primaryColor,
              ),
              onChanged: (Content newValue) {
                setState(() {
                  model.selectedChapter = newValue;
                  activeStep++;
                });
              },
              items: model.selectedCourse.content
                  .map<DropdownMenuItem<Content>>((Content value) {
                return DropdownMenuItem<Content>(
                  value: value,
                  child: Text(value.chapter),
                );
              }).toList(),
            ),
          ),
        );
      case 3:
        return Container(
          alignment: Alignment.center,
          width: SizeConfig.widthMultiplier * 80,
          child: SizedBox(
            width: SizeConfig.widthMultiplier * 75,
            child: DropdownButton<Lessons>(
              hint: Text(locale.get('Select Lesson')),
              selectedItemBuilder: (BuildContext context) {
                return model.selectedChapter.lessons
                    .where((element) => element.type == 'video')
                    .map((Lessons item) {
                  return Container(
                    width: SizeConfig.widthMultiplier * 68,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name),
                        item.isDone
                            ? Icon(Icons.check, color: AppColors.red)
                            : SizedBox()
                      ],
                    ),
                  );
                }).toList();
              },
              dropdownColor: AppColors.accentText,
              iconSize: 24,
              value: model.selectedLesson,
              autofocus: true,
              elevation: 16,
              style: const TextStyle(color: AppColors.primaryColor),
              underline: Container(
                height: 0.5,
                color: AppColors.primaryColor,
              ),
              onChanged: (Lessons newValue) {
                setState(() {
                  model.selectedLesson = newValue;
                  model.showAlertDialog(context);
                });
              },
              items: model.selectedChapter.lessons
                  .where((element) => element.type == 'video')
                  .map<DropdownMenuItem<Lessons>>((Lessons value) {
                return DropdownMenuItem<Lessons>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
        );

      default:
        return Text(activeStep.toString());
    }
  }

  /// Returns the next button.
  Widget nextButton() {
    return Container(
      width: SizeConfig.widthMultiplier * 45,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NormalButton(
          text: locale.get('Next Step'),
          color: AppColors.primaryColor,
          onPressed: () {
            if (activeStep <= upperBound) {
              setState(() {
                activeStep++;
              });
            }
          },
        ),
      ),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return Container(
      width: SizeConfig.widthMultiplier * 45,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NormalButton(
          text: locale.get('Previous Step'),
          color: AppColors.primaryColor,
          onPressed: () {
            if (activeStep > 1) {
              setState(() {
                activeStep--;
              });
            }
          },
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Text(
        headerText(),
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor),
      ),
    );
  }

  String headerText() {
    switch (activeStep) {
      case 1:
        return locale.get('Select Course');

      case 2:
        return locale.get('Select Chapter');

      case 3:
        return locale.get('Select Lesson');
    }
    return "";
  }
}

class BottomNavigationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Consumer<MainUITeacherVM>(builder: (context, model, __) {
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
                        height: SizeConfig.heightMultiplier * 3,
                        width: SizeConfig.widthMultiplier * 15,
                        color: model.currentPage == 0
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    ),
                    Text(
                      locale.get('Home'),
                      style: TextStyle(
                        fontSize: 14,
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
                        'assets/images/Courses.svg',
                        height: SizeConfig.heightMultiplier * 3,
                        width: SizeConfig.widthMultiplier * 15,
                        color: model.currentPage == 1
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    ),
                    Text(
                      locale.get('Courses'),
                      style: TextStyle(
                        fontSize: 14,
                        color: model.currentPage == 1
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 70,
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width * .15,
            //   child: Container(
            //     child: SvgPicture.asset(
            //       'assets/images/Courses.svg',
            //       height: SizeConfig.heightMultiplier * 3,
            //       width: SizeConfig.widthMultiplier * 15,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
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
                        'assets/images/Notifications.svg',
                        height: SizeConfig.heightMultiplier * 3,
                        width: SizeConfig.widthMultiplier * 15,
                        color: model.currentPage == 2
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    ),
                    Text(
                      locale.get('Notifications'),
                      style: TextStyle(
                        fontSize: 14,
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
                        'assets/images/Profile.svg',
                        height: SizeConfig.heightMultiplier * 3,
                        width: SizeConfig.widthMultiplier * 15,
                        color: model.currentPage == 3
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                    ),
                    Text(
                      locale.get('Profile'),
                      style: TextStyle(
                        fontSize: 14,
                        color: model.currentPage == 3
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
