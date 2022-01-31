part of 'message.dart';

class _MineMessage extends StatelessWidget {
  const _MineMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    final messageStatus = getMineMessageStatus(channel, message);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(left: 30),
          decoration: ShapeDecoration(
            color: BrandColors.blue1,
            shape: _MessageShape(isRight: true),
          ),
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Text(
              message.text ?? '',
              style: TextStyle(color: BrandColors.white),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
            child: Container()
            // TimeStatus(
            //   status: messageStatus,
            //   dateTime: message.createdAt,
            // ),
          ),
        )
      ],
    );
  }
}
