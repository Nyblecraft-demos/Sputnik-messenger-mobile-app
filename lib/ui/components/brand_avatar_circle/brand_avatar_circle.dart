import 'dart:math' show cos, sin, pi;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:sputnik/logic/model/user_extension.dart';

class BrandAvatarCircle extends StatelessWidget {
  const BrandAvatarCircle({
    Key? key,
    required this.user,
    this.size = 40,
    this.circleColor = BrandColors.primary,
    this.backgroundColor = Colors.white,
    this.showOutlineBorder = false,
    this.showStatus = false,
    this.statusSize = 12,
    this.statusAngle = 135,
  }) : super(key: key);

  final User? user;
  final double size;
  final Color backgroundColor;
  final Color circleColor;
  final bool showOutlineBorder;

  final bool showStatus;
  final double statusSize;
  final double statusAngle;

  Color get statusColor => user != null && user!.online ? CupertinoColors.activeGreen : CupertinoColors.secondaryLabel;

  @override
  Widget build(BuildContext context) {
    debugPrint('Avatar:   name = ${user?.name}    avatar = ${user?.avatar}  / ${user?.avatar?.length}   status = ${user?.status?.imageUrl}');

    return UnconstrainedBox(
      child: Container(
        width: size,
        height: size,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              //foregroundDecoration: foregroundDecoration,
              child: _AvatarImage(user),
            ),
            if (showStatus)
              CornerBox(
                offset: OffsetUtils.angleToOffset(statusAngle, radius: size / 2),
                child: Container(
                  width: statusSize,
                  height: statusSize,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: backgroundColor, width: 3),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  final String _dropDownValue = "Abc";
  Widget dropDownMenu() {
    return DropdownButton(
      hint: _dropDownValue == null
          ? Text('Dropdown')
          : Text(
              _dropDownValue,
              style: TextStyle(color: Colors.blue),
            ),
      isExpanded: true,
      iconSize: 30.0,
      style: TextStyle(color: Colors.blue),
      items: ['One', 'Two', 'Three'].map(
        (val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(val),
          );
        },
      ).toList(),
      onChanged: (val) {},
    );
  }

  Widget _AvatarImage(User? user) => user != null && user.avatar != null
      ? Image.network(
          user.avatar!,
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) => _Abbreviation(user),
        )
      : _Abbreviation(user);

  Widget _Abbreviation(User? user) => user != null
      ? _checkName(user)
      : defaultAvatar;

  Widget get defaultAvatar {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: CupertinoColors.quaternarySystemFill,
          //borderRadius: BorderRadius.circular(50),
          shape: BoxShape.circle),
      child: Center(child: Icon(CupertinoIcons.person_solid, color: CupertinoColors.secondaryLabel, size: size / 2.618)),
    );
  }

  Widget _textAvatar(String text) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text.toAbbreviation(),
          style: TextStyle(color: Colors.white, fontSize: size / 3, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _checkName(User user) {
    if (user.name != user.id) {
        return _textAvatar(user.name);
    }
    if (user.nickname.isNotEmpty) {
      return _textAvatar(user.nickname);
    }
    return defaultAvatar;
  }

  Widget _Avatar() {
    var hasStatus = user?.status?.imageUrl != null;
    var hasAvatar = user?.avatar != null ? !(user?.avatar == 'null' || user?.avatar == '') : false;
    debugPrint('Avatar Widget:  name = ${user?.name}  has status = $hasStatus,  has avatar = $hasAvatar,  avatar = ${user?.avatar}  / ${user?.avatar?.length} ');

    if (hasStatus) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: Image.network(
          user!.status!.imageUrl!,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: Container(
            color: hasAvatar ? backgroundColor : BrandColors.blue1,
            alignment: Alignment.center,
            width: size,
            height: size,
            child: hasAvatar
                ? Image.network(
                    user!.avatar!,
                    fit: BoxFit.cover,
                    height: size,
                    width: size,
                  )
                : Center(
                    child: Text(
                    user!.name.substring(0, 2).toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: size / 3, fontWeight: FontWeight.w500),
                  ))),
      );
    }
  }

  Widget _OutlineBorder() => LayoutBuilder(
        builder: (ctx, constraints) => ClipRRect(
          borderRadius: BorderRadius.circular(size),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
                colors: [Color(0xFFE34848), Color(0xFF6563FF)],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size),
              child: Container(
                width: size - 2,
                height: size - 2,
                color: backgroundColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    width: size - 4,
                    height: size - 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size),
                      child: Image.network(
                        user!.status!.imageUrl!,
                        fit: BoxFit.cover,
                        width: size * 0.90,
                        height: size * 0.90,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class CornerBox extends StatelessWidget {
  CornerBox({
    Key? key,
    required this.child,
    this.offset = Offset.zero,
  }) : super(key: key);

  /// Offset position.
  final Offset offset;

  /// Child widget.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: 0,
      height: 0,
      left: offset.dx,
      top: offset.dy,
      child: OverflowBox(
        alignment: Alignment.center,
        minWidth: 0,
        minHeight: 0,
        maxWidth: double.maxFinite,
        maxHeight: double.maxFinite,
        child: child,
      ),
    );
  }
}

/// Offset utility extension.
extension OffsetUtils on Offset {
  /// Returns Offset based on [angle] and [radius].
  static Offset angleToOffset(double angle, {double radius = 0.0}) {
    return Offset(
      radius * sin(pi * 2 * angle / 360) + radius,
      radius * -cos(pi * 2 * angle / 360) + radius,
    );
  }
}

/// String utility extension.
extension StringUtils on String? {
  /// Returns a string abbreviation.
  String toAbbreviation() {
    if (this == null) return '';

    final nameParts = this!.trim().toUpperCase().split(RegExp(r'[\s\/]+'));

    if (nameParts.length > 1) {
      return nameParts.first.substring(0, 1) + nameParts.last.substring(0, 1);
    }

    return nameParts.first.substring(0, 1);
  }
}

/*
@override
  Widget build(BuildContext context) {
    var hasStatus = contact?.status?.imageUrl != null;
    var hasAvatar = contact?.avatar != null ? !(contact?.avatar == 'null' || contact?.avatar == '') : false;
    debugPrint('Avatar Widget:  hasStatus = $hasStatus  hasAvatar = $hasAvatar  name = ${contact?.name}  avatar = ${contact?.avatar}  / ${contact?.avatar?.length} ');

    if (hasStatus) {
      var theme = context.watch<BrandTheme>();
      return ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(size),
            //border: Border.all(width: 1),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              colors: [
                Color(0xFFE34848),
                Color(0xFF6563FF)
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size),
            child: Container(
              width: size - 2,
              height: size - 2,
              color: theme.colorTheme.bubleBackground,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size),
                child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    width: size,
                    height: size,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size),
                      child: Image.network(
                        contact!.status!.imageUrl!,
                        fit: BoxFit.cover,
                        width: size * 0.90,
                        height: size * 0.90,
                      ),
                    )),
              ),
            ),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: Container(
            color: BrandColors.blue1,
            alignment: Alignment.center,
            width: size,
            height: size,
            child: hasAvatar
                ? Image.network(contact!.avatar!,
                    fit: BoxFit.cover,
                    height: size,
                    width: size,
                  )
                : Center(
                    child: Text(
                      contact != null ? contact!.name.substring(0, 2).toUpperCase() : '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size / 3,
                          fontWeight: FontWeight.w500),
                    )
                  )
            ),
      );
    }
  }
 */
