import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/core/services/notification/notification_service.dart';
import 'package:ts_academy/ui/pages/shared/change_Language/change_language_view.dart';
import 'package:ts_academy/ui/pages/student/Auth/verify_account/verify_account_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/mainUITeacher.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2)).then((value) async {
        locator<NotificationService>().init();
        AuthenticationService auth = locator<AuthenticationService>();
        if (auth.userLoged) {
          // await auth.signOut;
          locator<AuthenticationService>().loadUser;
          if (auth.user.isActive) {
            if (auth.user.userType == "Student") {
              UI.pushReplaceAll(context, MainUI());
            } else if (auth.user.userType == "Teacher") {
              final locale = AppLocalizations.of(context);
              if (auth.user.teacherApproved == true)
                UI.pushReplaceAll(context, MainUITeacher());
              else {
                UI.pushReplaceAll(context, MainUITeacher());
                UI.showSnackBarMessage(
                    context: context,
                    message:
                        locale.get('Please wait until approve your account'));
              }
            } else {
              UI.pushReplaceAll(
                  context,
                  MainUI(
                    isParent: true,
                  ));
            }
          } else {
            UI.pushReplaceAll(context, VerifyAccountPage());
          }
        } else {
          UI.pushReplaceAll(context, ChangeLanguagePage());
          // UI.pushReplaceAll(context, VerifyAccountPage());
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Center(
              child: Image.asset(
        "assets/images/Logo.png",
        width: SizeConfig.widthMultiplier * 20,
      ))),
    );
  }
}
