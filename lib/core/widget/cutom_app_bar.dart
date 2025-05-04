import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payment_app/core/utils/syles.dart';

AppBar buildAppBar({required BuildContext context, final String? title}) {
  return AppBar(
    leading: GestureDetector(
      onTap: () {
        Navigator.pop(context); // يرجّع المستخدم للخلف
      },
      child: Center(
        child: SvgPicture.asset(
          'assets/images/arrow.svg',
        ),
      ),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    title: Text(
      title ?? '',
      textAlign: TextAlign.center,
      style: Styles.style25,
    ),
  );
}
