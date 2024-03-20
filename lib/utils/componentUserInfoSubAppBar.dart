import 'package:flutter/material.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';

class UserInfoSubBar extends StatelessWidget {
  const UserInfoSubBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiServiceMahmoud().getUserProfile(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message if fetching fails
        } else {
          // Extract username and email from the snapshot data
          String username = snapshot.data!['username'];
          String email = snapshot.data!['email'];

          return Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset('lib/assets/images/Curio.png'),
                radius: 30,
              ),
              SizedBox(width: 10), // Adjust spacing between avatar and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'u/$username', // Display retrieved username
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(email), // Display retrieved email
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
