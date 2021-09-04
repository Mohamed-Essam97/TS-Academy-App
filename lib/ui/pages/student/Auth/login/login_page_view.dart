import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/register/register_page_view.dart';
import 'package:ts_academy/ui/pages/student/Auth/reset_password/reset_password_view.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';
import 'package:ts_academy/ui/routes/ui.dart';

import 'login_page_view_model.dart';

class StudentLoginPage extends StatelessWidget {
  bool isEng = true;
  bool _obscureText = true;
  final bool isParent;

  StudentLoginPage({Key key, this.isParent = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<StudentLoginPageModel>(
      create: (context) => StudentLoginPageModel(),
      child: Consumer<StudentLoginPageModel>(builder: (context, model, __) {
        model.isParent = isParent;
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReactiveForm(
                    formGroup: model.form,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              locale.get(
                                      "Sign in ${!model.isParent ? locale.get("As Student or Teacher") ?? "As Student or Teacher" : locale.get("Parent") ?? "Parent"}") ??
                                  "Sign in ${!model.isParent ? locale.get("As Student or Teacher") ?? "As Student or Teacher" : locale.get("Parent") ?? "Parent"}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 8,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: ReactiveField(
                              borderColor: Colors.black,
                              enabledBorderColor: AppColors.borderColor,
                              hintColor: Colors.black,
                              type: ReactiveFields.TEXT,
                              controllerName: 'username',
                              keyboardType: TextInputType.number,
                              label:
                                  locale.get('Phone number') ?? 'Phone number',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          model.isParent
                              ? Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: ReactiveField(
                                    borderColor: Colors.black,
                                    enabledBorderColor: AppColors.borderColor,
                                    hintColor: Colors.black,
                                    type: ReactiveFields.TEXT,
                                    controllerName: 'studentId',
                                    label: locale.get('Student ID') ??
                                        'Student ID',
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 20,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: ReactiveField(
                              borderColor: Colors.black,
                              enabledBorderColor: AppColors.borderColor,
                              secure: _obscureText,
                              type: ReactiveFields.PASSWORD,
                              iconButton: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.red,
                                ),
                                onPressed: () {
                                  _obscureText = !_obscureText;
                                  print(_obscureText);
                                  model.setState();
                                },
                              ),
                              controllerName: 'password',
                              label: locale.get('Password') ?? 'Password',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                UI.push(context, StudentResetPasswordPage());
                              },
                              child: Text(
                                locale.get("Forgot Password ?"),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ReactiveFormConsumer(
                            builder: (context, formGroup, child) {
                              return NormalButton(
                                onPressed: () {
                                  if (formGroup.valid) {
                                    model.login(context);
                                  } else {}
                                },
                                text: "Sign in",
                                color: formGroup.valid
                                    ? AppColors.primaryColor
                                    : Colors.blueGrey,
                                raduis: 2,
                                bold: false,
                              );
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(locale.get("Haven't Account?") + "   "),
                              InkWell(
                                onTap: () {
                                  UI.push(context, StudentRegisterPage());
                                },
                                child: Text(
                                  locale.get('Sign up'),
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: InkWell(
                              onTap: () {
                                if (model.isParent) {
                                  model.isParent = false;
                                  model.setState();
                                } else {
                                  model.isParent = true;
                                  model.setState();
                                }
                              },
                              child: Text(
                                model.isParent
                                    ? locale
                                        .get('Sign in As Student or Teacher')
                                    : locale.get("Sign in As Parent"),
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      }),
    );
  }
}
