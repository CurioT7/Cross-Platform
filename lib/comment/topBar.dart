import 'dart:math';
import 'package:flutter/material.dart';

AppBar topAppBar(BuildContext context) {
  return AppBar(
    flexibleSpace: Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Color.fromRGBO(
              200 + Random().nextInt(56), // R value in RGB
              200 + Random().nextInt(56), // G value in RGB
              200 + Random().nextInt(56), // B value in RGB
              1, // opacity
            ),
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
