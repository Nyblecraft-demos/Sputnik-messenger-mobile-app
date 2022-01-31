import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide showMenu;
import 'package:flutter/material.dart' as material show showMenu;
import 'package:sputnik/config/brand_colors.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

mixin CustomPopupMenu<T extends StatefulWidget> on State<T> {
  Offset? _tapPosition;

  void storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

    Future<T?> showMenu<T>({
      required BuildContext context,
      required List<PopupMenuEntry<T>> items,
      T? initialValue,
      double? elevation,
      String? semanticLabel,
      ShapeBorder? shape,
      bool useRootNavigator = false,
    }) {
      final Size? size = Overlay.of(context)?.context.size;

      return material.showMenu<T>(
        context: context,
        position: RelativeRect.fromLTRB(
          _tapPosition?.dx ?? 0,
          _tapPosition?.dy ?? 0,
          (size?.width ?? 0) - (_tapPosition?.dx ?? 0),
          (size?.height ?? 0) - (_tapPosition?.dy ?? 0),
        ),
        items: items,
        initialValue: initialValue,
        elevation: elevation,
        semanticLabel: semanticLabel,
        shape: shape,
        color: Colors.transparent,
        useRootNavigator: useRootNavigator,
      );
    }
}

class PopUpEntry extends PopupMenuEntry<int> {
  const PopUpEntry({this.message, this.replyCallBack, required this.content});
  final Message? message;
  final Function(Message message)? replyCallBack;
  final List<PopUpEntryElement> content;

  @override
  final double height = 100;

  @override
  bool represents(int? n) => n == 1 || n == -1;

  @override
  PopUpEntryState createState() => PopUpEntryState();
}

class PopUpEntryState extends State<PopUpEntry> {

  @override
  Widget build(BuildContext context) {
    return _popUpMenu;
  }
  Widget get _popUpMenu {
    var isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      width: 140,
      decoration: BoxDecoration(
          color: isDarkMode ? Color(0x40252525) : Color(0xBFFFFFFF),
          borderRadius: BorderRadius.circular(10)),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10)
              ),
            child: Column(
              children: _contentList(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _contentList() {
    var list = <Widget>[];
    for (var i = 0; i < widget.content.length; i++) {
      list.add(widget.content[i]);
      if (i != widget.content.length - 1) {
        list.add(_divider);
      }
    }
    return list;
  }

  Widget get _divider {
    var isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Divider(
      color: isDarkMode ? Color(0xA6545458) : Color(0xA6545458),
    );
  }

}

class PopUpEntryElement extends StatelessWidget {
  const PopUpEntryElement({this.action, this.color, required this.text, required this.iconData, Key? key,}) : super(key: key);

  final IconData iconData;
  final String text;
  final Function? action;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => action != null ? action!() : null,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(color: color),
            ),
            Spacer(),
            Icon(iconData, size: 20, color: color != null ? color : Color(0xFF6B95FF)),
          ],
        ),
      ),
    );
  }
}