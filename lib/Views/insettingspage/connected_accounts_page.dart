import 'package:flutter/material.dart';
import 'package:curio/utils/component_app_bar.dart';

class ConnectedAcountsPage extends StatelessWidget {
  const ConnectedAcountsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(
        title: 'Reset password',
      ),
     
    );
  }
}
