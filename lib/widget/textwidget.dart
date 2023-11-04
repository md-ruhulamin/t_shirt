import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  double size;
   TextWidget({super.key, required this.text ,required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize:size ,fontWeight:FontWeight.bold),
    );
  }
}
