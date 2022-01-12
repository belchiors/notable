import 'package:flutter/material.dart';
import 'package:notable/model/note_model.dart';

class ListItem extends StatelessWidget {
  final Note item;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final bool? isSelected;

  const ListItem(
      {Key? key,
      required this.item,
      this.isSelected,
      this.onTap,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      shape: Theme.of(context).cardTheme.shape,
      child: ListTile(
        shape: Theme.of(context).listTileTheme.shape,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        selected: isSelected!,
        title: Text(
          item.title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(
          item.body!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
