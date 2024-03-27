import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutCommunityAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AboutCommunityAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Start by using a Column to stack things vertically.
    return Column(
      mainAxisSize: MainAxisSize.min, // This makes the Column only as tall as its children need.
      children: [
        AppBar(
          backgroundColor: Colors.transparent, // Make the app bar transparent
          elevation: 0, // Remove the shadow
          flexibleSpace: Stack(
            children: [
              Image.asset(
                'lib/assets/images/bannerimage.png', // Your image from assets
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100, // Cover the entire app bar
              ),
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                bottom: 0, // Adjusted to cover the entire app bar
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'r/PrequelMemes', // The name of the community.
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.green, size: 10), // Online status indicator
                              SizedBox(width: 4.0),
                              Text(
                                '366 Collecting Fine Additions', // The online members count.
                                style: TextStyle(color: Colors.white, fontSize: 12.0),
                              ),

                            ],
                          ),
                              ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.search_rounded, color: Colors.white),
                            onPressed: () {
                              // Implement the search action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share_outlined, color: Colors.white),
                            onPressed: () {
                              // Implement the join action or bookmarking
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert_outlined, color: Colors.white),
                            onPressed: () {
                              // Implement the join action or bookmarking
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Here is the new Row with your buttons.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // This spreads out the buttons evenly in the Row.
            children: [
              TextButton(
                onPressed: () {
                  // What to do when the Menu button is pressed
                },
                child: Text('About', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  // What to do when the Info button is pressed
                },
                child: Text('Menu', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(190); // Adjust the total height to accommodate the buttons.
}

