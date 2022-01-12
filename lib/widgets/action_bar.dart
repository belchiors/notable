import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:notable/widgets/action_button.dart';

class ActionBar extends StatefulWidget with PreferredSizeWidget {
  final Widget? defaultAppBar;
  final Widget? actionBarTitle;
  final bool display;
  final void Function()? onClose;
  final List<Widget>? actions;

  ActionBar({
    Key? key,
    this.defaultAppBar,
    this.actionBarTitle,
    this.onClose,
    required this.display,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  @override
  Widget build(BuildContext context) {
    if (!widget.display) {
      return widget.defaultAppBar!;
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: AppBar(
        title: widget.actionBarTitle,
        leading: ActionButton(
          icon: Icon(FluentIcons.dismiss_24_regular),
          onPressed: () {
            widget.onClose!();
            setState(() {});
          },
        ),
        actions: widget.actions,
      ),
    );
  }
}
