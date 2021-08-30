import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {

  final String headerTitle;

  const SectionHeader({Key? key, required this.headerTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            thickness: 2.0,
            height: 16.0,
            endIndent: 16.0,
          ),
        ),
        Text(
          headerTitle,
          style: TextStyle(
            fontSize: 20.0,
            decoration: TextDecoration.underline,
            fontStyle: FontStyle.italic,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 2.0,
            height: 16.0,
            indent: 16.0,
          ),
        )
      ],
    );
  }
}