import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

class Loading extends StatelessWidget {
  final double loadingImageHeight;

  const Loading({this.loadingImageHeight});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: PlaceholderLines(
        count: 5,
        animate: true,
        align: TextAlign.center,
      )),
    );
  }
}
