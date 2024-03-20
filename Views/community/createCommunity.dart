import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curio/services/logicAPI.dart';
import 'package:flutter/widgets.dart';

class createCommunity extends StatefulWidget {
  @override
  _createCommunityState createState() => _createCommunityState();
}

class _createCommunityState extends State<createCommunity> {
  String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWY0NDI4NGI4YjFjMTM5OWNkOGFiMjIiLCJpYXQiOjE3MTA3ODgxNjEsImV4cCI6MTcxMDg3NDU2MX0.Dkf0kU7xh_jppyR07VJveTUi78aI45J_NpvxX1XGRio';
  String? errorMessage;
  bool isSwitched = false;
  bool isButtonEnabled = false;
  bool isButtonLoading = false;
  bool isValidCommunityName = true; //Connect to backend
  String listTileTitle = "Public";
  String listTileSubtitle =
      "Anyone can view, post, and comment to this community";
  final TextEditingController _textEditingController = TextEditingController();
  final logicAPI apiLogic = logicAPI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Create a community',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.width * 0.002),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.1,
                    spreadRadius: 0.2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.035,
                  top: MediaQuery.of(context).size.width * 0.055,
                  bottom: MediaQuery.of(context).size.width * 0.015,
                ),
                child: Text(
                  'Community name:',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontFamily: 'IBM Plex Sans'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.035,
                    vertical: MediaQuery.of(context).size.width * 0.002),
                child: TextField(
                  controller: _textEditingController,
                  focusNode: myFocusNode,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    height: MediaQuery.of(context).size.width * 0.002,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[400]?.withOpacity(0.2),
                    hintText: myFocusNode.hasFocus ? '' : 'r/Community_name',
                    suffix: Text(
                      "${21 - _textEditingController.text.length} ",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    hintStyle: TextStyle(
                        color: Colors.grey[130],
                        fontFamily: 'IBM Plex Sans Light'),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixText: 'r/',
                    border: InputBorder.none,
                    errorText: errorMessage,
                    errorStyle: TextStyle(color: Colors.grey),
                    errorMaxLines: 2,
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (_textEditingController.text.length == 0 ||
                          _textEditingController.text.length == 21) {
                        isButtonLoading = false;
                        return;
                      }
                      isButtonLoading = true;
                    });
                  },
                  onEditingComplete: () {
                    RegExp regex = RegExp(r'^[a-zA-Z0-9_]+$');
                    bool isMatch = regex.hasMatch(_textEditingController.text);

                    if (_textEditingController.text.length < 22 &&
                        (_textEditingController.text.length >= 3) &&
                        isValidCommunityName &&
                        isMatch) {
                      setState(() {
                        isButtonLoading = false;
                        isButtonEnabled = true;
                        errorMessage = null;
                      });
                    } else {
                      setState(() {
                        isButtonLoading = false;
                        isButtonEnabled = false;
                        if (isMatch == false ||
                            _textEditingController.text.length < 3) {
                          errorMessage =
                              'Community names must be between 3-21 characters and'
                              ' can only contain letters, numbers, or underscores.';
                        }
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.035,
                  top: MediaQuery.of(context).size.width * 0.04,
                  bottom: MediaQuery.of(context).size.width * 0.015,
                ),
                child: Text(
                  'Community type:',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontFamily: 'IBM Plex Sans'),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Map<String, String>? result =
                      await _displayTypeCommunityBottomSheet(context);

                  if (result != null) {
                    setState(() {
                      listTileTitle = result['title'] ?? listTileTitle;
                      listTileSubtitle = result['subtitle'] ?? listTileSubtitle;
                    });
                  }
                },
                child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.12,
                    child: ListTile(
                      title: Text(
                        "$listTileTitle",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                      subtitle: Text("$listTileSubtitle"),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                        onPressed: () {},
                      ),
                    )),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04,
                    ), // Adjust padding as needed
                    child: Text(
                      '18+ community',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05,
                    ), // Adjust padding as needed
                    child: Switch.adaptive(
                      activeTrackColor: Colors.blueAccent[400],
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey[200],
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              Center( child:
              ElevatedButton(

                onPressed: isButtonEnabled
                    ? () {
                        setState(() {
                          // Set loading state if needed
                        });
                        apiLogic.createCommunity(_textEditingController.text,
                                listTileTitle, isSwitched, token)
                            .then((_) {
                          setState(() {
                            Text('Community cxreated succssfully');
                          });
                        }).catchError((error) {
                          setState(() {
                            // Handle errors here
                            print('Error creating community: $error');
                          });
                        });
                      }
                    : null,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!isButtonLoading)
                      Text(
                        'Create community',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    if (isButtonLoading)
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                  ],
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(
                      MediaQuery.of(context).size.width * 0.9, // Width
                      MediaQuery.of(context).size.width * 0.12, // Height
                    ),
                  ),

                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey.shade200;
                      }
                      return Colors.blue.shade900;
                    },
                  ),
                ),
              )
              )
            ],
          ),
        ));
  }

  FocusNode myFocusNode = FocusNode();
}

void isCommunityNameValid() {}
Future<Map<String, String>?> _displayTypeCommunityBottomSheet(
    BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
          height: MediaQuery.of(context).size.width * 0.9,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.095,
                  child: Divider(
                    thickness: 3,
                    color: Colors.grey,
                  ),
                ),
                Center(
                    child: Text(
                  'Community type',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                  ),
                )),
                ListTile(
                  contentPadding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                  ),
                  leading: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.black26.withOpacity(0.5),
                    size: MediaQuery.of(context).size.width * 0.07,
                  ),
                  title: Text(
                    'Public',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Anyone can view, post, and comment to this community',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans ',
                      color: Colors.black26.withOpacity(0.6),
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                  onTap: () => {
                    Navigator.pop(context, {
                      'title': 'Public',
                      'subtitle':
                          'Anyone can view, post, and comment to this community'
                    })
                  },
                ),
                ListTile(
                    contentPadding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                    ),
                    leading: Icon(
                      Icons.task_alt,
                      color: Colors.black26.withOpacity(0.5),
                      size: MediaQuery.of(context).size.width * 0.07,
                    ),
                    title: Text(
                      'Restricted',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Anyone can view this community, but only approved users can post',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans ',
                        color: Colors.black26.withOpacity(0.6),
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                      ),
                    ),
                    onTap: () => {
                          Navigator.pop(context, {
                            'title': 'Restricted',
                            'subtitle':
                                'Anyone can view this community, but only approved users can post'
                          })
                        }),
                ListTile(
                    contentPadding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                    ),
                    leading: Icon(
                      Icons.lock_outlined,
                      color: Colors.black26.withOpacity(0.5),
                      size: MediaQuery.of(context).size.width * 0.07,
                    ),
                    title: Text(
                      'Private',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Only approved users can view and submit to this community',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans ',
                        color: Colors.black26.withOpacity(0.6),
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                      ),
                    ),
                    onTap: () => {
                          Navigator.pop(
                            context,
                            {
                              'title': 'Private',
                              'subtitle':
                                  'Only approved users can view and submit to this community'
                            },
                          )
                        }),
              ],
            ),
          ));
    },
  );
}
