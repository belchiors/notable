import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Icon? icon;
  final void Function()? onPressed;

  ActionButton({this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: this.icon!, onPressed: this.onPressed, splashRadius: 22.0);
  }
}
