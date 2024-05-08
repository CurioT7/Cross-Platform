import 'package:flutter/material.dart';

class CreateRulePage extends StatefulWidget {
  @override
  _CreateRulePageState createState() => _CreateRulePageState();
}

class _CreateRulePageState extends State<CreateRulePage> {
  final _formKey = GlobalKey<FormState>();
  String _reportReasonAppliesTo = 'Posts and comments';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create rule'),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle save
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Rule Title',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              maxLength: 500,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Rule Description',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Report Reason',
              ),
            ),
            SizedBox(height: 20),
            Text('Report reason applies to:'),
            ListTile(
              title: const Text('Posts and comments'),
              leading: Radio<String>(
                value: 'Posts and comments',
                groupValue: _reportReasonAppliesTo,
                onChanged: (String? value) {
                  setState(() {
                    _reportReasonAppliesTo = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Only comments'),
              leading: Radio<String>(
                value: 'Only comments',
                groupValue: _reportReasonAppliesTo,
                onChanged: (String? value) {
                  setState(() {
                    _reportReasonAppliesTo = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Only posts'),
              leading: Radio<String>(
                value: 'Only posts',
                groupValue: _reportReasonAppliesTo,
                onChanged: (String? value) {
                  setState(() {
                    _reportReasonAppliesTo = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}