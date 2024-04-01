import 'dart:ui' as ui;
import 'package:flutter/material.dart';

AppBar topAppBar(BuildContext context, ValueNotifier<double> blurValue) {
  return AppBar(
    flexibleSpace: Stack(
      children: [
        Positioned.fill(
          child: ValueListenableBuilder<double>(
            valueListenable: blurValue,
            builder: (context, value, child) {
              return ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: value, sigmaY: value),
                child: Image.asset(
                    'assets/images/example.jpg',
                  width: MediaQuery.of(context).size.width * 1.5,
                  height: MediaQuery.of(context).size.width * 0.15,
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        ),
        Positioned(
          right: MediaQuery.of(context).size.width * 0.01,
          top: MediaQuery.of(context).size.width * 0.04,
          child: ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.search, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[900]?.withOpacity(0.5),
              shape: CircleBorder(),
            ),
          ),
        ),
      ],
    ),
  );
}