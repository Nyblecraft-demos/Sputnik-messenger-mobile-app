import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/ui/components/brand_alert.dart';
import 'package:sputnik/ui/components/brand_avatar_circle/brand_avatar_circle.dart';
import 'package:sputnik/ui/components/brand_icons/brand_icons.dart';
import 'package:sputnik/ui/components/message/image.dart';
import 'package:sputnik/ui/components/message/moderation.dart';
import 'package:sputnik/ui/components/message/popUp_mixin.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/user_pofile/user_profile.dart';
import 'package:sputnik/utils/get_stream_helpers.dart';

import 'package:sputnik/utils/time_helpers.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

part 'incoming_message.dart';

part 'mine_message.dart';
part 'message_popUp.dart';
part 'message_shape.dart';

class MessageWidget extends StatefulWidget {
  MessageWidget(
      {Key? key,
      required this.message,
      required this.lastRead,
      required this.theme,
      required this.replyCallBack,
      required this.tapReplyCallBack,
      this.tapsAllowed = true})
      : super(key: key);

  final Message message;
  final DateTime lastRead;
  final BrandTheme theme;
  final Function(Message message) replyCallBack;
  final Function(Message message) tapReplyCallBack;
  bool tapsAllowed;

  @override
  MessageWidgetState createState() => MessageWidgetState();
}

class MessageWidgetState extends State<MessageWidget> with CustomPopupMenu {
  late Future<FileInfo?> savedFile;

  @override
  void initState() {
    getFileFromCache();
    super.initState();
  }

  Future<FileInfo?> getFileFromCache() async {
    if (widget.message.attachments.isNotEmpty) {
      if (widget.message.attachments[0].assetUrl != null) {
        savedFile = DefaultCacheManager().getFileFromCache(
          widget.message.attachments[0].assetUrl!,
        );
      }
    }
  }

  Future<FileInfo?> getFileFromUrl(String assetUrl) async {
    savedFile = (DefaultCacheManager().downloadFile(
      widget.message.attachments[0].assetUrl!,
    ));
    return savedFile;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = getIt.get<ChatService>().currentUser;
    getFileFromCache();
    return content(
        data: widget.message,
        isOpponent: widget.message.user?.id != currentUser.id,
        context: context);
  }

  Widget content(
      {required Message data,
      required isOpponent,
      required BuildContext context}) {
    final primaryColor =
        isOpponent ? widget.theme.colorTheme.hintText : Colors.white;
    final secondaryColor =
        isOpponent ? BrandColors.lightSecondaryGray3 : const Color(0x99EBEBF5);
    final primaryStyle = TextStyle(color: primaryColor);
    final secondaryStyle =
        TextStyle(color: secondaryColor, fontWeight: FontWeight.w400);
    final isFlaggedMessagesOn =
        context.read<AppSettingsCubit>().isFlaggedMessagesOn ?? false;
    if (data.deletedAt != null) {
      return Row(
          mainAxisAlignment:
              isOpponent ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment:
              isOpponent ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                decoration: boxDecoration(isOpponent: isOpponent),
                child: Text(
                  AppLocalizations.of(context)?.messegeDeleted ?? '',
                  style: TextStyle(color: widget.theme.colorTheme.grayText),
                ))
          ]);
    }

    if (data.attachments.isNotEmpty) {
      return Row(
        mainAxisAlignment:
            isOpponent ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment:
            isOpponent ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (isOpponent && widget.message.user != null) ...[
            GestureDetector(
              onTap: () {
                if (widget.tapsAllowed)
                  Navigator.of(context).push(
                      materialRoute(UserProfile(user: widget.message.user!)));
              },
              child: Container(
                height: 20,
                width: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BrandAvatarCircle(
                    user: widget.message.user!,
                    size: 20,
                  ),
                  // child: Image.asset('assets/images/mock.png'),
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          Column(
            children: [
              Stack(
                children: [
                  LongPressDetector(
                      child: GestureDetector(
                          onTapDown: storePosition,
                          onLongPress: _showCustomMenu,
                          child: messageWithAttachments(context, isOpponent))),
                  _checkFlagMessage(isFlaggedMessagesOn)
                ],
              )
            ],
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment:
          isOpponent ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isOpponent) ...[
          GestureDetector(
            onTap: () {
              if (widget.tapsAllowed)
                Navigator.of(context).push(
                    materialRoute(UserProfile(user: widget.message.user!)));
            },
            child: Container(
              height: 20,
              width: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BrandAvatarCircle(
                  user: widget.message.user,
                  size: 20,
                ),
                // child: Image.asset('assets/images/mock.png'),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
        LongPressDetector(
          child: GestureDetector(
            onTapDown: storePosition,
            onLongPress: _showCustomMenu,
            child: Stack(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                decoration: boxDecoration(isOpponent: isOpponent),
                child: Column(
                  crossAxisAlignment: isOpponent
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      child: Column(
                          crossAxisAlignment: isOpponent
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          children: [
                        data.quotedMessage != null ? _replyMessage(primaryStyle, isOpponent) : SizedBox.shrink(),
                        Text(data.text ?? '', style: primaryStyle)
                      ]),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        (widget.lastRead.isAfter(widget.message.createdAt))
                            ? Icon(BrandIcons.check2,
                                size: 12, color: secondaryColor)
                            : Icon(BrandIcons.check1,
                                size: 12, color: secondaryColor),
                        SizedBox(width: 4),
                        Text(timeToString(widget.message.createdAt),
                            style: secondaryStyle.copyWith(fontSize: 10)),
                      ],
                    )
                  ],
                ),
              ),
              _checkFlagMessage(isFlaggedMessagesOn)
            ]),
          ),
        ),
      ],
    );
  }

  Widget _checkFlagMessage(bool isFlaggedMessagesOn) {
    if (widget.message.extraData['messageModeration'] != null &&
        widget.message.extraData['messageModeration'] == true) {
      return flaggedMessage(widget.message.id, isFlaggedMessagesOn);
    } else {
      return Container();
    }
  }

  Widget LongPressDetector({required Widget child}) {
    return OpenContainer(
        closedColor: Colors.transparent,
        closedElevation: 0,
        openBuilder: (context, _) => Container(),
        closedBuilder: (context, _) => Container(child: child));
  }

  Widget messageWithAttachments(BuildContext context, bool isOpponent) {
    final primaryColor = isOpponent ? CupertinoColors.label : Colors.white;
    final secondaryColor =
        isOpponent ? const Color(0x4D3C3C43) : const Color(0x99EBEBF5);
    final primaryStyle = TextStyle(color: primaryColor);
    final secondaryStyle =
        TextStyle(color: secondaryColor, fontWeight: FontWeight.w400);
    var element = widget.message.attachments[0];
    // File
    if (element.assetUrl != null && element.assetUrl!.isNotEmpty) {
      return fileMessage(element, isOpponent, primaryStyle, secondaryStyle);
    }
    // Image
    if (element.imageUrl != null && element.imageUrl!.isNotEmpty) {
      return Container(
//        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        decoration: boxDecoration(isOpponent: isOpponent),
        child: Container(
//                height: 150,
//                width: MediaQuery.of(context).size.width,
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 120),
          child: Column(
            children: [
              if (widget.message.text != null &&
                  widget.message.text!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 7.0,
                    right: 7.0,
                    top: 7.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(widget.message.text ?? '',
                              style: primaryStyle)),
                    ],
                  ),
                ),
              if (widget.message.text != null &&
                  widget.message.text!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 5.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(CupertinoIcons.checkmark_alt,
                          size: 12, color: secondaryColor),
                      SizedBox(width: 4),
                      Text(timeToString(widget.message.createdAt),
                          style: secondaryStyle.copyWith(fontSize: 10))
                    ],
                  ),
                ),
              ClipRRect(
                borderRadius: isOpponent
                    ? BorderRadius.only(
                        bottomRight: Radius.circular(
                          10,
                        ),
                      )
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(
                          10,
                        ),
                      ),
                child: OpenContainer(
                  openBuilder: (context, _) =>
                      ImagePage(imageUrl: element.imageUrl!),
                  closedBuilder: (context, VoidCallback openContainer) =>
                      GestureDetector(
                    onTap: () {
                      if (widget.tapsAllowed) openContainer();
                    },
                    child: CachedNetworkImage(
                      imageUrl: element.imageUrl!,
                      placeholder: (context, url) => Container(),
                      errorWidget: (context, url, error) => Container(),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),

//                  Image.network(
//                    element.imageUrl!,
//                    fit: BoxFit.fitWidth,
//                  ),
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Widget fileMessage(Attachment element, bool isOpponent,
      TextStyle primaryStyle, TextStyle secondaryStyle) {
//    if(savedFile) return Text("B");
    return FutureBuilder(
        future: savedFile,
        builder: (BuildContext context, AsyncSnapshot<FileInfo?> snapshot) {
          return GestureDetector(
            onTap: () {
              if (widget.tapsAllowed && snapshot.hasData) {
                OpenFile.open(snapshot.data!.file.path);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              decoration: boxDecoration(isOpponent: isOpponent),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 120),
              child: Column(
                children: [
                  widget.message.quotedMessage != null ? _replyMessage(primaryStyle, isOpponent) : SizedBox.shrink(),
                  if (widget.message.text != null &&
                      widget.message.text!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(widget.message.text ?? '',
                                style: primaryStyle)),
                      ],
                    ),
                  if (widget.message.text != null &&
                      widget.message.text!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(CupertinoIcons.checkmark_alt,
                            size: 12, color: secondaryStyle.color),
                        SizedBox(width: 4),
                        Text(timeToString(widget.message.createdAt),
                            style: secondaryStyle.copyWith(fontSize: 10))
                      ],
                    ),
                  Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Color(0xFFE0E5EC),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: fileIcon(
                              context, snapshot, isOpponent, element.assetUrl!),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          element.title ?? "file",
                          style: primaryStyle,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool fileLoading = false;

  Widget fileIcon(BuildContext context, AsyncSnapshot<FileInfo?> snapshot,
      bool isOpponent, String assetUrl) {
    if (fileLoading) return CircularProgressIndicator();
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        // loading
        return Icon(
          Icons.insert_drive_file_rounded,
          color: isOpponent ? Color(0xFF9BB3D4) : BrandColors.primary,
        );
      case ConnectionState.done:
        if (snapshot.hasData) {
          // open files
          return isOpponent
              ? GestureDetector(
                  onTap: () {
                    if (widget.tapsAllowed) {
                      OpenFile.open(snapshot.data!.file.path);
                    }
                  },
                  child: Icon(
                    Icons.insert_drive_file_rounded,
                    color: Color(0xFF9BB3D4),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    if (widget.tapsAllowed) {
                      OpenFile.open(snapshot.data!.file.path);
                    }
                  },
                  child: Icon(
                    Icons.insert_drive_file_rounded,
                    color: BrandColors.primary,
                  ),
                );
        } else {
          //download files
          return GestureDetector(
            onTap: () async {
              if (widget.tapsAllowed) {
                setState(() {
                  fileLoading = true;
                });
                await getFileFromUrl(assetUrl);
                setState(() {
                  fileLoading = false;
                });
              }
            },
            child: Icon(
              Icons.arrow_downward_outlined,
              color: isOpponent ? Color(0xFF9BB3D4) : BrandColors.primary,
            ),
          );
        }
      default:
        if (snapshot.hasError)
          // download files
          return GestureDetector(
            onTap: () async {
              if (widget.tapsAllowed) {
                setState(() {
                  fileLoading = true;
                });
                await getFileFromUrl(assetUrl);
                setState(() {
                  fileLoading = false;
                });
              }
            },
            child: Icon(
              Icons.arrow_downward_outlined,
              color: isOpponent ? Color(0xFF9BB3D4) : BrandColors.primary,
            ),
          );
        else
          // open files
          return GestureDetector(
            onTap: () {
              if (widget.tapsAllowed) {
                OpenFile.open(snapshot.data!.file.path);
              }
            },
            child: Icon(
              Icons.insert_drive_file_rounded,
              color: isOpponent ? Color(0xFF9BB3D4) : BrandColors.primary,
            ),
          );
    }
  }

  BoxDecoration boxDecoration({required bool isOpponent, bool reply = false}) {
    final boxShdow = BoxShadow(
      color: Colors.white.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 10,
      offset: Offset(0, 0),
    );
    return isOpponent
        ? BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(13),
              bottomLeft: Radius.circular(13),
              bottomRight: Radius.circular(13),
            ),
            color: widget.theme.colorTheme.opponentChat,
      boxShadow: reply? [boxShdow] : []
          )
        : BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(13),
              bottomLeft: Radius.circular(13),
              bottomRight: Radius.circular(13),
            ),
            color: widget.theme.colorTheme.mineChat,
        boxShadow: reply? [boxShdow] : []
          );
  }

  BoxDecoration photoAttachBoxDecoration({required bool isOpponent}) {
    return isOpponent
        ? BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(
                10,
              ),
            ),
            color: CupertinoColors.quaternarySystemFill,
          )
        : BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                10,
              ),
            ),
            color: BrandColors.primary,
          );
  }

  void _showCustomMenu() {
    this.showMenu(
      context: context,
      items: <PopupMenuEntry<int>>[
        PopUpEntry(
          message: widget.message,
          replyCallBack: widget.replyCallBack,
          content: contentPopUp(),
        )
      ],
    );
  }

  Widget _replyMessage(TextStyle textStyle, bool isOpponent) {
    var color = !isOpponent ? widget.theme.colorTheme.hintText : Colors.white;
    return GestureDetector(
      onTap: () { widget.tapReplyCallBack(widget.message.quotedMessage!); },
      child: Column(
        children: [Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
          decoration: boxDecoration(isOpponent: !isOpponent, reply: true),
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                _replyAttachments(color),
                SizedBox(height: 10,),
                Text(widget.message.quotedMessage?.text ?? '', style: TextStyle(color: color))
              ],
            ),
          ),
        ),
        SizedBox(height: 10,)]
      ),
    );
  }

  Widget _replyAttachments(Color color) {
    if (widget.message.quotedMessage?.attachments.isEmpty == true) {
      return SizedBox.shrink();
    } else {
      Attachment? element = widget.message.quotedMessage?.attachments[0];
      if (element == null) { return SizedBox.shrink(); }
      if (element.assetUrl != null && element.assetUrl?.isNotEmpty == true) {
        return Row(
          mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insert_drive_file_rounded, color: color, size: 20,),
              SizedBox(width: 5,),
              Text(element.title ?? '', style: TextStyle(color: color),)
            ]);
      }
      if (element.imageUrl != null && element.imageUrl?.isNotEmpty == true) {
        return CachedNetworkImage(
          imageUrl: element.imageUrl!,
          placeholder: (context, url) => Container(),
          errorWidget: (context, url, error) => Container(),
          fit: BoxFit.fitWidth,
        );
      }
      return Container();
    }
  }
}