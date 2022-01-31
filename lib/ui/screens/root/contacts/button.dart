part of './contacts.dart';

class ContactTileButton extends StatelessWidget {
  const ContactTileButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPress,
    this.hasTopBoarder = false,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onPress;
  final bool hasTopBoarder;

  @override
  Widget build(BuildContext context) {
    var borderColor = context.watch<BrandTheme>().colorTheme.backgroundColor1;
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          border: Border(
            top: hasTopBoarder
                ? BorderSide(
                    width: 1,
                    color: borderColor,
                  )
                : BorderSide.none,
            bottom: BorderSide(
              width: 1,
              color: borderColor,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 21,
        ),
        child: Row(
          children: [
            BlueCircle(icon),
            SizedBox(
              width: 14,
            ),
            Text(
              text,
              style: context.watch<BrandTheme>().light,
            )
          ],
        ),
      ),
    );
  }
}
