import 'package:flutter/material.dart';
import 'sideBarAfterLogIn.dart';
import 'package:curio/Views/signUp/signup.dart';
class sideBarBeforeLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // child: Container( // Beginning of Container
      //   margin: EdgeInsets.only(
      //     top: MediaQuery.of(context).size.width * 0.09,
      //     bottom: MediaQuery.of(context).size.width * 0.09,
      //   ),

      child: ListView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.09,
          bottom: MediaQuery.of(context).size.width * 0.09,
        ),
        children: <Widget>[
          Container(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: MediaQuery.of(context).size.width * 0.23,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.04,
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: Text(
                    'Sign up to upvote the best content, customize your feed, share your interests, and more!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).size.width * 0.09,
            ),
            leading: Icon(
              Icons.account_circle,
              color: Colors.black,
              size: MediaQuery.of(context).size.width * 0.05,
            ),
            title: Text(
              'Sign up / Log in',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.045,
              ),
            ),
            onTap: () => {Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              )},
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              top: MediaQuery.of(context).size.width * 1.1,
            ),
            leading: Icon(
              Icons.settings_outlined,
              color: Colors.black,
              size: MediaQuery.of(context).size.width * 0.05,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => {
              Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => sidebarAfterLogIn()),
              )
            },
          ),
        ],
      ),
    );
  }
}
