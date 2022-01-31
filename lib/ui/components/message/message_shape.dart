part of 'message.dart';

class _MessageShape extends ShapeBorder {
  _MessageShape({this.isRight = false});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  final bool isRight;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    var xLeft = rect.left;
    var xRight = rect.right;

    var y0 = rect.top;

    var path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect,
          Radius.circular(10),
        ),
      )
      ..addPath(
        isRight
            ? _triangle(isRight ? xRight : xLeft, y0)
            : _triangle(xLeft, y0),
        Offset(-6, 17.5),
      );
    return path;
  }

  Path _triangle(
    double x,
    double y,
  ) {
    return Path()
      ..moveTo(x, y)
      ..lineTo(x + 12.12, y)
      ..lineTo(x + 12.12 / 2, y + 10.5)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
