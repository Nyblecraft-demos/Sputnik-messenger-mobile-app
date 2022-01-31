import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/ui/components/brand_icons/brand_icons.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.Hm();

class TimeStatus extends StatelessWidget {
  const TimeStatus({
    Key? key,
    required this.unreadMessages,
    required this.dateTime,
    required this.color,
    required this.opponentUnread
  }) : super(key: key);

  final int unreadMessages;
  final DateTime dateTime;
  final Color color;
  final bool opponentUnread;

  @override
  Widget build(BuildContext context) {
    //var theme = context.watch<BrandTheme>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 1),
        unreadMessages == 0 ? _icon : Badge(
          position: BadgePosition.topEnd(top: -12, end: 5),
          animationDuration: Duration(milliseconds: 300),
          animationType: BadgeAnimationType.scale,
          badgeColor: BrandColors.blue1,
          badgeContent: Text('$unreadMessages', style: TextStyle(color: Colors.white),),
          child: Container(),
        ),
        Text(
          formatter.format(dateTime.toLocal()),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: color),
        ),
      ],
    );
  }

  Widget get _icon {
    var color = BrandColors.blue1;
    IconData iconData;
    // iconData = BrandIcons.check1;

    if (opponentUnread) {
      iconData = BrandIcons.check1;
    } else {
      iconData = BrandIcons.check2;
    }

    // switch (status) {
    //   case MessageStatus.sending:
    //     iconData = BrandIcons.check1;
    //     color = CupertinoColors.secondaryLabel;
    //     break;
    //   case MessageStatus.recived:
    //     iconData = BrandIcons.check2;
    //     color = CupertinoColors.secondaryLabel;
    //     break;
    //   case MessageStatus.read:
    //     iconData = BrandIcons.check2;
    //     color = BrandColors.blue1;
    //     break;
    // }
    return Icon(iconData, color: color, size: 17);
  }
}

// Widget _time(BrandTheme theme) {
//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       SizedBox(width: 1),
//       if (message.hasSent && !message.hasRecived)
//         Icon(
//           BrandIcons.check1,
//           color: BrandColors.blue1,
//           size: 18,
//         ),
//       if (message.hasSent && message.hasRecived)
//         Icon(
//           BrandIcons.check2,
//           color: BrandColors.blue1,
//           size: 18,
//         ),
//       Text(
//         message.time,
//         style: theme.small,
//       ),
//     ],
//   );
// }
