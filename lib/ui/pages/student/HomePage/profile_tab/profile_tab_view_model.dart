import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/settings.model.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import '../../../../../core/providers/provider_setup.dart';
import '../../../../../core/services/auth/authentication_service.dart';
import '../../../../../core/services/localization/localization.dart';
import '../../../../../core/services/preference/preference.dart';
import '../../../../styles/colors.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:dio/src/multipart_file.dart';

class ProfileTabPageModel extends BaseNotifier {
  final BuildContext context;
  final AppLocalizations locale;
  AuthenticationService auth;

  Settings settings;
  ProfileTabPageModel({this.context, this.locale}) {
    auth = locator<AuthenticationService>();
    bioController.text = auth?.user?.bio;
    getSettings();
  }

  changeLanguage(String lang) async {
    Provider.of<AppLanguageModel>(context, listen: false)
        .changeLanguage(Locale(lang));
  }

  Future<dynamic> languageDialog() {
    var result = showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locale.get("Language"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                RadioListTile(
                  activeColor: AppColors.primaryColor,
                  title: Text(
                    "English",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  value: 0,
                  groupValue:
                      Preference.getString(PrefKeys.languageCode) == 'en'
                          ? 0
                          : 1,
                  selected: Preference.getString(PrefKeys.languageCode) == 'en',
                  onChanged: (value) {
                    setState(() {});
                    changeLanguage("en");
                    Navigator.of(ctx).pop(true);
                  },
                ),
                RadioListTile(
                  activeColor: AppColors.primaryColor,
                  title: Text(
                    "العربية",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  value: 1,
                  groupValue:
                      Preference.getString(PrefKeys.languageCode) == 'ar'
                          ? 1
                          : 0,
                  selected: Preference.getString(PrefKeys.languageCode) == 'ar',
                  onChanged: (value) {
                    setState(() {});
                    changeLanguage("ar");
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return result;
  }

  TextEditingController bioController = TextEditingController();

  changeAvatar() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: resultList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: locale.get('TS Academy App'),
          allViewTitle: locale.get('All Photos'),
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    List<MultipartFile> uploadedFiles = <MultipartFile>[];
    for (var i = 0; i < resultList.length; i++) {
      ByteData byteData = await resultList[i].getByteData(quality: 5);
      List<int> imageData = byteData.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(imageData);

      uploadedFiles.add(multipartFile);
    }
    setBusy();
    var res = await api.uploadImage(context, image: uploadedFiles[0]);
    res.fold((e) => UI.toast(e.message), (data) async {
      String path = data['id'];
      bool result =
          await auth.updateUserProfile(context, body: {'avatar': path});
      if (result) {
        var updatedUser = await api.myProfile(context);
        if (updatedUser != null) {
          updatedUser.fold((e) => ErrorWidget(e), (d) {
            auth.saveUser(User.fromJson(d));
          });
          UI.showSnackBarMessage(
            context: context,
            message: locale.get("Avatar has been updated"),
          );
        }
      } else {
        UI.toast("Something went wrong please try again later.");
      }
      setIdle();
      setState();
    });
  }

  Future<void> updateBio() async {
    String bio = bioController.text;
    if (bioController.text.isNotEmpty) {
      setBusy();
      bool result = await auth.updateUserProfile(context, body: {'bio': bio});
      if (result) {
        var updatedUser = await api.myProfile(context);
        if (updatedUser != null) {
          updatedUser.fold((e) => ErrorWidget(e), (d) {
            auth.saveUser(User.fromJson(d));
          });
          UI.showSnackBarMessage(
            context: context,
            message: locale.get("Bio has been updated"),
          );
        }
      } else {
        UI.toast("Something went wrong please try again later.");
      }
      setIdle();
      setState();
    }
  }

  getSettings() async {
    settings = await api.getSettings(context);
  }
}
