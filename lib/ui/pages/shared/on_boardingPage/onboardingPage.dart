import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/shared/on_boardingPage/onboarding_view_model.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

class OnBoardingPage extends StatelessWidget {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<OnBoardingViewModel>(
        create: (context) => OnBoardingViewModel(),
        child: Consumer<OnBoardingViewModel>(builder: (context, model, __) {
          return Scaffold(
              body: SafeArea(
            child: Container(
              child: model.busy
                  ? Loading()
                  : model.onBoarding == null || model.onBoarding.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("onBoarding is empty!"),
                              SizedBox(height: 30),
                              NormalButton(
                                raduis: 0,
                                color: AppColors.primaryColor,
                                height: 40,
                                width: 60,
                                text: "Sign in",
                                onPressed: () {
                                  UI.push(context, StudentLoginPage());
                                },
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: locale.locale.languageCode == 'en'
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: ToggleSwitch(
                                    minWidth: 50.0,
                                    minHeight: 35.0,
                                    fontSize: 13.0,
                                    initialLabelIndex:
                                        locale.locale.languageCode == 'en'
                                            ? 1
                                            : 0,
                                    activeBgColor: AppColors.primaryColor,
                                    activeFgColor: Colors.grey[100],
                                    inactiveBgColor: Colors.grey[100],
                                    inactiveFgColor: Colors.grey[900],
                                    labels: ['عر', 'En'],
                                    onToggle: (index) {
                                      print(index);
                                      Provider.of<AppLanguageModel>(context,
                                              listen: false)
                                          .changeLanguage(Locale(
                                              locale.locale.languageCode == 'en'
                                                  ? 'ar'
                                                  : 'en'));
                                    }),
                              ),
                            ),
                            Container(
                              height: SizeConfig.heightMultiplier * 50,
                              child: PageView.builder(
                                itemCount: model?.onBoarding?.length ?? 0,
                                controller: controller,
                                itemBuilder:
                                    (BuildContext context, int itemIndex) {
                                  return itemWidget(context, model, itemIndex);
                                },
                              ),
                            ),
                            SmoothPageIndicator(
                              controller: controller,
                              count: model?.onBoarding?.length,
                              textDirection: locale.locale.languageCode == 'en'
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              axisDirection: Axis.horizontal,
                              effect: ExpandingDotsEffect(
                                  spacing: 8.0,
                                  radius: 30,
                                  dotWidth: 15.0,
                                  dotHeight: 10.0,
                                  paintStyle: PaintingStyle.fill,
                                  dotColor: Colors.grey,
                                  activeDotColor: AppColors.primaryColor),
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      //
                                      await model.requestToken();
                                      UI.push(context, MainUI(isParent: false),
                                          replace: true);
                                    },
                                    child: Text(
                                      locale.get("Sign in later"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 15),
                                    ),
                                  ),
                                  NormalButton(
                                    raduis: 0,
                                    color: AppColors.primaryColor,
                                    height: 40,
                                    width: 60,
                                    text: locale.get('Sign in'),
                                    onPressed: () {
                                      UI.push(context, StudentLoginPage());
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
            ),
          ));
        }));
  }

  Widget itemWidget(BuildContext context, OnBoardingViewModel model, index) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: "${model.api.imagePath}${model.onBoarding[index].image}",
          imageBuilder: (context, imageProvider) => Container(
            width: SizeConfig.widthMultiplier * 50,
            height: SizeConfig.heightMultiplier * 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain,
              ),
            ),
          ),
          placeholder: (context, url) => Loading(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 7,
        ),
        Text(
          model.onBoarding[index].title.localized(context),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
