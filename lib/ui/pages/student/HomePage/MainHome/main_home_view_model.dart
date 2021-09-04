import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';

class MainUIVM extends BaseNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  PageController controller = PageController();

  onSwipe(int page) {
    // Logger().w(page);
    _currentPage = page;
    setState();
  }

  changePage(int page) {
    // Logger().w(page);
    _currentPage = page;
    controller
        .animateToPage(page,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate)
        .then((value) {
      print(page);
    });
    setState();
  }
}
