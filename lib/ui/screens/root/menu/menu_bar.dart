import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dart:math' as math;

/// Single convex button widget
class MenuAppBar extends StatelessWidget {

  final double convexWidth;
  final double convexHeight;

  /// The distance to edge from the bottom of child widget.
  final double top;

  /// Height of bottom border
  final double barHeight;

  /// child widget
  final Widget child;

  /// child margin
  final double margin;

  /// Color for the button
  final Color backgroundColor;

  /// Make new instance of [ConvexButton]
  const MenuAppBar({
    Key? key,
    this.convexWidth = 60,
    this.convexHeight = 24,
    this.top = 20,
    this.barHeight = 16.0,
    required this.child,
    required this.margin,
    required this.backgroundColor,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: <Widget>[
      _Background(context),
      child,
    ]);
  }

  Widget _Background(BuildContext context) =>
      Container(
        height: barHeight + MediaQuery.of(context).padding.bottom,
        width: double.infinity,
        child: CustomPaint(
          painter: ConvexPainter(
            top: -top,
            width: convexWidth,
            height: convexHeight,
            color: backgroundColor,
          ),
        ),
      );
}

/// Custom painter to draw the [ConvexNotchedRectangle] into canvas.
class ConvexPainter extends CustomPainter {
  final _paint = Paint();
  late ConvexNotchedRectangle _shape;

  /// Width of the convex shape.
  final double width;

  /// Height of the convex shape.
  final double height;

  /// Position in vertical which describe the offset of shape.
  final double top;

  /// Create painter
  ConvexPainter({
    required this.top,
    required this.width,
    required this.height,
    Color color = Colors.white,
  }) : super() {
    _paint.color = color;
    _shape = ConvexNotchedRectangle();
  }

  @override
  void paint(Canvas canvas, Size size) {
    var host = Rect.fromLTWH(0, 0, size.width, size.height);
    var percent = 0.5;
    var guest = Rect.fromLTWH(size.width * percent - width / 2, top, width, height);
    var path = _shape.getOuterPath(host, guest);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(ConvexPainter oldDelegate) {
    return oldDelegate._paint != _paint;
  }
}

/// A convex shape which implemented [NotchedShape].
///
/// It's used to draw a convex shape for [ConvexAppBar], If you are interested about
/// the math calculation, please refer to [CircularNotchedRectangle], it's based
/// on Bezier curve;
///
/// See also:
///
///  * [CircularNotchedRectangle], a rectangle with a smooth circular notch.
class ConvexNotchedRectangle extends NotchedShape {

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) return Path()..addRect(host);

    // The guest's shape is a circle bounded by the guest rectangle.
    // So the guest's radius is half the guest width.
    final notchRadius = guest.width / 2.0;

    const s1 = 15.0;
    const s2 = 1.0;

    final r = notchRadius;
    final a = -1.0 * r - s2;
    final b = host.top - guest.center.dy;

    final n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final p2yA = -math.sqrt(r * r - p2xA * p2xA);
    final p2yB = -math.sqrt(r * r - p2xB * p2xB);

    final p = List<Offset>.filled(6, Offset.zero, growable: false);
    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

    // translate all points back to the absolute coordinate system.
    for (var i = 0; i < p.length; i += 1) {
      p[i] = p[i] + guest.center;
      //p[i] += padding;
    }

    return (Path()
      ..moveTo(host.left, host.top)
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
      ..arcToPoint(
        p[3],
        radius: Radius.circular(notchRadius),
        clockwise: true,
      )
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close());
  }
}