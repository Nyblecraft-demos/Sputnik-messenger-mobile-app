part of 'message.dart';

extension on MessageWidgetState {

  List<PopUpEntryElement> contentPopUp() {
    return [
      PopUpEntryElement(
        text: AppLocalizations.of(context)?.reply ?? '',
        iconData: CupertinoIcons.arrowshape_turn_up_left_fill,
        action: _replyCallBack,
        ),
      PopUpEntryElement(
        text: AppLocalizations.of(context)?.copy ?? '',
        iconData: CupertinoIcons.doc_on_clipboard_fill,
        action: _copyMessage,
      ),
      PopUpEntryElement(
        text: AppLocalizations.of(context)?.report ?? '',
        iconData: CupertinoIcons.exclamationmark,
        action: _showFlagAlert,
      ),
      PopUpEntryElement(
        text: AppLocalizations.of(context)?.delete ?? '',
        iconData: CupertinoIcons.delete,
        action: _delete,
        color: Colors.red,
      ),
    ];
  }

  void _replyCallBack() {
    Navigator.of(context).pop();
    widget.replyCallBack(widget.message);
  }

  void _showFlagAlert() {
    BrandAlert.show(
        context: context,
        title: AppLocalizations.of(context)?.report ?? '',
        subtitle: AppLocalizations.of(context)?.messageReport ?? '',
        secondaryButtonTitle: AppLocalizations.of(context)?.cancel,
        secondaryButtonAction: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        mainButtonTitle: 'Ok',
        mainButtonAction: _flagMessage);
  }

  Future _flagMessage() async {
    final client = getIt.get<ChatService>().client;
    client.flagMessage(widget.message.id);
    await client.updateMessage(widget.message.copyWith(extraData: {'messageModeration': true}));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _copyMessage() {
    Clipboard.setData(ClipboardData(text: widget.message.text));
    final snackBar = SnackBar(
      duration: Duration(milliseconds: 300),
      backgroundColor: BrandColors.primary,
      content: Row(
        children: [
          Icon(CupertinoIcons.doc_on_clipboard_fill, size: 20, color: Colors.white),
          SizedBox(width: 8,),
          Text(AppLocalizations.of(context)?.copyInfo ?? '', style: TextStyle(color: Colors.white), )
        ],
      ),
    );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _delete() async {
    final client = getIt.get<ChatService>().client;
    await client.deleteMessage(widget.message.id);
    Navigator.of(context).pop();
  }
}