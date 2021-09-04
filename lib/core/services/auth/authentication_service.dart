import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/ui/routes/ui.dart';

import '../preference/preference.dart';

class AuthenticationService extends BaseNotifier {
  //for testing only remove the init
  User _user;

  User get user => _user;

  /*
   *check if user is authenticated
   */
  bool get userLoged => Preference.getBool(PrefKeys.userLogged) ?? false;

  /*
   *save user in shared prefrences
   */
  saveUser(User user) {
    Preference.setString(PrefKeys.userData, json.encode(user.toJson()));
    Preference.setString(PrefKeys.token, user.token);
    Preference.setBool(PrefKeys.userLogged, true);
    _user = user;
    // Logger().i(json.encode(user.toJson()));
  }

  saveToken(String token) {
    Preference.setString(PrefKeys.token, token);
    Preference.setBool(PrefKeys.userLogged, false);
    _user = null;
  }

  updateUserProfile(BuildContext context, {Map<String, dynamic> body}) async {
    var res = await api.updateUserProfile(
      context,
      body: body,
    );
    User user;
    res.fold((error) {
      UI.toast(error.message);
    }, (data) {
      print(data);
      user = User.fromJson(data);
      if (user != null) {
        saveUser(user);
      }
    });
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  saveFirstToken(String token) {
    _user = User(token: token);
  }

  /*
   * load the user info from shared prefrence if existed to be used in the service
   */
  Future<void> get loadUser async {
    _user = User.fromJson(json.decode(Preference.getString(PrefKeys.userData)));
    // Logger().i(json.encode(_user.toJson()));
    // Logger().i("TOKEN:  " + _user.token);
  }

  //  login with user name and pass

  /*
   * signout the user from the app and return to the login screen   
   */
  Future<void> get signOut async {
    await Preference.sb.clear();
    _user = null;
  }

  static handleAuthExpired({@required BuildContext context}) async {
    if (context != null) {
      try {
        // Logger().v('🦄ready to destroy session🦄');

        Preference.setBool(PrefKeys.userLogged, false);

        // UI.pushReplaceAll(context, Routes.splashScreen);

        // Logger().v('🦄session destroyed🦄');
      } catch (e) {
        // Logger().v('🦄error while destroying session🦄');
        // Logger().v('🦄$e🦄');
      }
    }
  }
}
