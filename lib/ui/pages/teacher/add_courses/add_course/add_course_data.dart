import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'add_course_data_model.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddCourseData extends StatelessWidget {
  Course course;
  AddCourseData({this.course});
  List<String> days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  List hours = [
    12.00,
    12.30,
    01.00,
    1.30,
    2.00,
    2.30,
    3.00,
    3.30,
    4.00,
    4.30,
    5.00,
    5.30,
    6.00,
    6.30,
    7.00,
    7.30,
    8.00,
    8.30,
    9.00,
    9.30,
    10.00,
    10.30,
    11.00,
    11.30
  ];
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<AddCourseDataModel>(
        create: (context) =>
            AddCourseDataModel(context: context, course: course),
        child: Consumer<AddCourseDataModel>(builder: (context, model, __) {
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: ReactiveForm(
                      formGroup: model.form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: SizeConfig.heightMultiplier * 10,
                            child: Center(
                              child: Text(
                                locale.get('Create Course'),
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          ReactiveField(
                            context: context,
                            borderColor: AppColors.borderColor,
                            enabledBorderColor: AppColors.borderColor,
                            hintColor: AppColors.borderColor,
                            textColor: AppColors.greyColor,
                            items: model.stages,
                            type: ReactiveFields.DROP_DOWN,
                            controllerName: 'stage',
                            label: locale.get('Stage'),
                          ),
                          ReactiveField(
                              context: context,
                              borderColor: AppColors.borderColor,
                              enabledBorderColor: AppColors.borderColor,
                              hintColor: AppColors.borderColor,
                              textColor: AppColors.greyColor,
                              items: model.grades,
                              type: ReactiveFields.DROP_DOWN,
                              controllerName: 'grade',
                              label: locale.get('Grade')),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ReactiveField(
                                context: context,
                                borderColor: AppColors.borderColor,
                                enabledBorderColor: AppColors.borderColor,
                                hintColor: AppColors.borderColor,
                                textColor: AppColors.greyColor,
                                items: model.subjects,
                                isObject: true,
                                type: ReactiveFields.DROP_DOWN,
                                controllerName: 'subject',
                                label: locale.get('Subject')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(locale.get('Course Image')),
                          ),
                          InkWell(
                            onTap: () {
                              model.openGallary(context);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .2,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.greyColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                              child: Center(
                                  child: model.form.control("cover").value ==
                                          null
                                      ? Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Colors.lightBlueAccent,
                                        )
                                      : Container(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${model.api.imagePath}${model.form.control("cover").value}",
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Loading(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ReactiveField(
                              context: context,
                              borderColor: AppColors.borderColor,
                              enabledBorderColor: AppColors.borderColor,
                              hintColor: AppColors.borderColor,
                              textColor: AppColors.greyColor,
                              // items: ["5", "4", "3", "2", "1"],
                              type: ReactiveFields.TEXT,
                              controllerName: 'name',
                              label: locale.get('Course Name'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ReactiveField(
                              context: context,
                              borderColor: AppColors.borderColor,
                              enabledBorderColor: AppColors.borderColor,
                              hintColor: AppColors.borderColor,
                              textColor: AppColors.greyColor,
                              // items: ["5", "4", "3", "2", "1"],
                              type: ReactiveFields.TEXT,
                              controllerName: 'info',
                              label: locale.get('Info'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ReactiveField(
                              context: context,
                              borderColor: AppColors.borderColor,
                              enabledBorderColor: AppColors.borderColor,
                              hintColor: AppColors.borderColor,
                              textColor: AppColors.greyColor,
                              type: ReactiveFields.TEXT,
                              keyboardType: TextInputType.number,
                              controllerName: 'price',
                              label: locale.get('Price'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ReactiveField(
                                context: context,
                                borderColor: AppColors.borderColor,
                                enabledBorderColor: AppColors.borderColor,
                                hintColor: AppColors.borderColor,
                                textColor: AppColors.greyColor,
                                // items: ["5", "4", "3", "2", "1"],
                                type: ReactiveFields.TEXT,
                                controllerName: 'description',
                                maxLines: 4,
                                label: locale.get('Description')),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: MultiSelectDialogField(
                                items: days
                                    .map((e) =>
                                        MultiSelectItem(e, locale.get(e)))
                                    .toList(),
                                listType: MultiSelectListType.CHIP,
                                onConfirm: (values) {
                                  model.selectedSteps.updateValue(values);
                                },
                                onSelectionChanged: (values) {
                                  model.selectedSteps.updateValue(values);
                                },
                                cancelText: Text(locale.get('Cancel')),
                                confirmText: Text(locale.get('Confirm')),
                                title: Text(locale.get('Select Days')),
                                autovalidateMode: AutovalidateMode.always,
                                buttonText: Text(locale.get('Select Days')),
                                buttonIcon: Icon(Icons.arrow_drop_down),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.0),
                                    border: Border.all(
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                        width: 0.5)),
                                selectedItemsTextStyle:
                                    TextStyle(color: Colors.white),
                                initialValue: model.selectedSteps.value,
                                chipDisplay: MultiSelectChipDisplay(
                                  items: model.selectedSteps.value
                                      .map((e) => MultiSelectItem(e, e))
                                      .toList(),
                                  alignment: Alignment.center,
                                  scroll: true,
                                  textStyle: TextStyle(color: Colors.black87),
                                  scrollBar:
                                      HorizontalScrollBar(isAlwaysShown: false),
                                ),
                                selectedColor: AppColors.primaryColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ReactiveDropdownField(
                              items: hours
                                  .map((item) => DropdownMenuItem<dynamic>(
                                        value: item,
                                        child: new Text(
                                          item.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ))
                                  .toList(),
                              style: TextStyle(color: Colors.black),
                              icon: Icon(
                                Icons.arrow_drop_down_rounded,
                              ),
                              decoration: InputDecoration(
                                  // labelStyle: TextStyle(color: Colors.blue),
                                  fillColor: ReactiveField().fillColor,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: ReactiveField().borderColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: AppColors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: AppColors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                      color: ReactiveField().textColor),
                                  hintStyle: TextStyle(
                                      color: ReactiveField().hintColor),
                                  labelText: locale.get('Choose Hour')

                                  // fillColor: Colors.white,
                                  ),
                              formControlName: 'hour',
                              // style: TextStyle(color: textColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(locale.get('Select Start Date')),
                                SfCalendar(
                                  view: CalendarView.month,
                                  todayHighlightColor: Colors.white,
                                  todayTextStyle:
                                      TextStyle(color: Colors.black),
                                  cellBorderColor: AppColors.primaryColor,
                                  minDate: DateTime.now(),
                                  showCurrentTimeIndicator: true,
                                  appointmentTextStyle:
                                      TextStyle(color: Colors.black),
                                  selectionDecoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      // backgroundBlendMode: BlendMode.color,
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          color: AppColors.secondaryElement,
                                          style: BorderStyle.solid,
                                          width: 0.5),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5,
                                            color: Colors.blueGrey[100])
                                      ]),
                                  viewNavigationMode: ViewNavigationMode.snap,
                                  monthViewSettings:
                                      MonthViewSettings(showAgenda: false),
                                  onTap: (CalendarTapDetails value) {
                                    model.form.control("startDate").updateValue(
                                        value.date.millisecondsSinceEpoch);
                                  },
                                ),
                              ],
                            ),
                          ),
                          ReactiveFormConsumer(
                            builder: (context, form, child) {
                              return NormalButton(
                                  color: form.valid
                                      ? AppColors.primaryColor
                                      : Colors.blueGrey,
                                  onPressed: () {
                                    if (form.valid) {
                                      if (course != null) {
                                        model.updateCourse();
                                      } else {
                                        model.createCourse();
                                      }
                                    } else {
                                      print('invalid');
                                    }
                                    // Logger().wtf(model.form.value);
                                  },
                                  child: Text(
                                    locale.get('Next'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ));
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }

  // dateTimePicker(context, model) {
  //   DatePicker.showDatePicker(context,
  //       showTitleActions: true,
  //       minTime: DateTime(1960, 3, 5),
  //       maxTime: DateTime.now(), onChanged: (date) {
  //     print('change $date');
  //   }, onConfirm: (date) {
  //     print('confirm $date');
  //     print(date.millisecondsSinceEpoch);
  //     model.form
  //         .control('birthDate')
  //         .updateValue(date.millisecondsSinceEpoch.toString());
  //     dateTime = date;
  //     model.setState();
  //   }, currentTime: DateTime.now(), locale: LocaleType.en);
  // }
}
