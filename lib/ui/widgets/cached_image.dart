import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../styles/colors.dart';

class CachedImage extends StatelessWidget {
  final double height;
  final double width;
  final String imageUrl;
  final BoxFit boxFit;
  CachedImage({
    @required this.imageUrl,
    this.height,
    this.width,
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit,
          ),
        ),
      ),
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          strokeWidth: 2.0,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.fill,
      ),
    );
  }
  // return FadeInImage(
  //   placeholder: AssetImage('assets/images/logo.png'),
  //   image: NetworkImage(imageUrl),
  //   imageErrorBuilder:
  //       (BuildContext context, Object exception, StackTrace stackTrace) {
  //     return Text('Your error widget...');
  //   },
  //   height: height,
  //   width: width,
  //   fit: boxFit,
  // );
  // }
}
