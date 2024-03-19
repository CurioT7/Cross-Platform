import 'package:flutter/material.dart';
class UserInfoSubBar extends StatelessWidget {
  const UserInfoSubBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Image.asset('lib/assets/images/Curio.png'),
          radius: 30,
        ),
        SizedBox(height: 10),
        Column(mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'u/Decent-Chain-163',
              style: TextStyle(fontWeight: FontWeight.bold,),
            ),
            Text('mahmoud9salah2002@gmail.com'),
          ],
        ),

      ],
    );
  }
}