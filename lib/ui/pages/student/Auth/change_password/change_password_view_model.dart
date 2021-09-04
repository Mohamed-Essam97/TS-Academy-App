import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/mainUITeacher.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class StudentChangePasswordPageModel extends BaseNotifier {
  FormGroup form;

  StudentChangePasswordPageModel() {
    form = FormGroup({
      'password': FormControl(
        validators: [
          Validators.required,
          Validators.required,
          Validators.minLength(8),
          Validators.maxLength(16),
          Validators.pattern(r'^(?=.*[a-z])')
        ],
      ),
      'confirmPassword': FormControl(
        validators: [
          Validators.required,
        ],
      ),
    }, validators: [
      Validators.mustMatch('password', 'confirmPassword'),
    ]);
  }

  User user;
  void changePassword(context) async {
    setBusy();
    var res = await api.changePassword(context, newPassword: form.control("password").value);
    print(form.value);
    res.fold((error) {
      setError();
      ErrorDialog().notification(
        error.message.toString(),
        Colors.red,
      );
    }, (data) {
      user = User.fromJson(data);
      locator<AuthenticationService>().saveUser(user);

      if (user.userType == "Student") {
        UI.pushReplaceAll(context, MainUI());
      } else if (user.userType == "Teacher") {
        UI.pushReplaceAll(context, MainUITeacher());
      } else if (user.userType == "Parent") {
        UI.pushReplaceAll(
            context,
            MainUI(
              isParent: true,
            ));
      }

      setIdle();
    });
  }
}
