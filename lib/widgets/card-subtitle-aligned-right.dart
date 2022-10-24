import 'package:flutter/material.dart';

class CardSubtitleAlignedRight extends StatelessWidget {
  CardSubtitleAlignedRight({super.key, this.title, this.value});

  String? value;
  String? title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text('${value}')],
          ),
          subtitle: Text('${title}')),
    );
  }
}
