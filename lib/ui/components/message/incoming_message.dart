part of 'message.dart';

class _IncomingMessage extends StatelessWidget {
  const _IncomingMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    // var isTyping = message.isTyping;
    var isTyping = false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.user != null)
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: BrandAvatarCircle(
                user: message.user!,
                size: 60,
              ),
              // child: Image.asset('assets/images/mock.png'),
            ),
          ),
        Flexible(
          child: isTyping
              ? _TypingMessage(message: message)
              : _TextMessage(message: message),
        ),
        SizedBox(width: 30),
      ],
    );
  }
}

class _TextMessage extends StatelessWidget {
  const _TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(left: 12),
          decoration: ShapeDecoration(
            color: theme.colorTheme.bubleBackground,
            shape: _MessageShape(),
          ),
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Text(
              message.text ?? '',
              style: TextStyle(color: theme.colorTheme.defaultText),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
          child: Row(
            children: [
              Text(
                message.user?.name ?? '',
                style: theme.small,
              ),
              Spacer(),
              Text(
                timeToString(message.createdAt),
                style: theme.small,
              )
            ],
          ),
        )
      ],
    );
  }
}

class _TypingMessage extends StatefulWidget {
  const _TypingMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  __TypingMessageState createState() => __TypingMessageState();
}

class __TypingMessageState extends State<_TypingMessage>
    with TickerProviderStateMixin {
  final controllers = <AnimationController>[];
  final animations = <Animation<double>>[];

  List<Widget> _widgets = <Widget>[];
  final tween = Tween(begin: 0.0, end: 3.0);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      controllers.add(
        AnimationController(duration: Duration(milliseconds: 250), vsync: this),
      );

      animations.add(
        tween.animate(controllers[i])
          ..addStatusListener(
            (AnimationStatus status) {
              if (status == AnimationStatus.completed) controllers[i].reverse();
              if (i == 2 && status == AnimationStatus.dismissed) {
                controllers[0].forward();
              }
              if (animations[i].value > 1 / 4 && i < 2) {
                controllers[i + 1].forward();
              }
            },
          ),
      );
      _widgets.add(JumpingDot(
        animation: animations[i],
        opacity: (3 - i) / 3,
      ));
    }

    controllers[0].forward();
  }

  @override
  void dispose() {
    for (int i = 0; i < 3; i++) controllers[i].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 90,
          margin: EdgeInsets.only(left: 12),
          decoration: ShapeDecoration(
            color: theme.colorTheme.bubleBackground,
            shape: _MessageShape(),
          ),
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _widgets,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
          child: Text(
            widget.message.user?.name ?? '',
            style: theme.small,
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        )
      ],
    );
  }
}

class JumpingDot extends AnimatedWidget {
  JumpingDot({
    Key? key,
    required Animation<double> animation,
    this.opacity = 1,
  }) : super(key: key, listenable: animation);

  final double opacity;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Padding(
      padding: EdgeInsets.only(top: 6 - animation.value),
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: BrandColors.grey2.withOpacity(opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
