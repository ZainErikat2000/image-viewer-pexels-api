import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton(
      {required this.onPressed,
      required this.text,
      required this.height,
      required this.padding,
      required this.borderRadius,
      required this.shadowBlurRadius,
      Key? key})
      : super(key: key);
  final String text;
  final double height;
  final double padding;
  final double borderRadius;
  final double shadowBlurRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: shadowBlurRadius)],
            borderRadius: BorderRadius.circular(borderRadius)),
        padding: EdgeInsets.only(left: padding, right: padding),
        height: 20,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
