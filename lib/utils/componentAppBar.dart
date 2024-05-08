import 'package:flutter/material.dart';
import 'package:curio/utils/constants.dart';

class ComponentAppBar extends AppBar {
  ComponentAppBar({Key? key,  title})
      : super(
    key: key,
    title: Text(title, style: kTitleTextStyle),

    iconTheme: IconThemeData(color: Colors.black),

  );
}
