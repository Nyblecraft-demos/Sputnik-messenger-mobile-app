import 'dart:io';
import 'package:cubit_form/cubit_form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/ui/helpers/phone_services/camera/camera.dart';
import 'package:sputnik/ui/helpers/phone_services/gallery/gallery.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/chat/attachment.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as path;

import '../brand_alert.dart';

final style = TextStyle(color: BrandColors.grey3, fontSize: 14);

final border = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent, width: 0.0),
  borderRadius: BorderRadius.circular(20),
  gapPadding: 0,
);

class BottomChatBar extends StatefulWidget {
  const BottomChatBar({
    Key? key,
    required this.onSend,
    required this.channel,
    required this.showAttachment,
  }) : super(key: key);

  final Future<void> Function(String text) onSend;
  final Channel channel;
  final bool showAttachment;
  final int maxLength = 20000000;

  @override
  _BottomChatBarState createState() => _BottomChatBarState();
}

class _BottomChatBarState extends State<BottomChatBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    newMessage = _controller.value.text.isNotEmpty || !widget.showAttachment;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late bool newMessage = false;

  @override
  Widget build(BuildContext context) {
    var theme = context.read<BrandTheme>();
    //var isDarkModeOn = context.read<AppSettingsCubit>().state.isDarkModeOn ?? true;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.quaternarySystemFill,
        // border: Border(
        //   top: BorderSide(
        //     color: isDarkModeOn ? BrandColors.black1 : BrandColors.grey2,
        //     width: 0.5,
        //   ),
        // ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Icon(CupertinoIcons.plus_circle, color: CupertinoColors.secondaryLabel, size: 26),
            //_AttachmentButton(),
            //SizedBox(width: 8),
//            BlocBuilder<FieldCubit, FieldCubitState>(
//              bloc: form.avatar,
//              builder: (context, state) => avatarWidget(context, state, form, width: 150, height: 150),
//            ),
            if (widget.showAttachment)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    openAttachment(
                      context,
                    );
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: newMessage ? BrandColors.primary : theme.colorTheme.hintText,
                  ),
                ),
              ),
            Expanded(
              child: Container(
                child: TextField(
                  minLines: 1,
                  maxLines: 4,
                  style: style.copyWith(color: theme.colorTheme.hintText),
                  scrollPadding: EdgeInsets.zero,
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {
                      newMessage = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: border,
                    focusedBorder: border,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                    filled: true,
                    hintStyle: style,
                    hintText: AppLocalizations.of(context)?.enterMessage,
                    fillColor: theme.colorTheme.inputBackgroundColor,
//                    prefixIcon: IconButton(
//                      icon: Icon(Icons.done),
//                      onPressed: () {
//
//                      },
//                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Transform.rotate(
              angle: 0.8,
              child: IconButton(
                  constraints: const BoxConstraints(),
                  //color: BrandColors.primary,
                  icon: Icon(CupertinoIcons.paperplane_fill, color: newMessage ? BrandColors.primary : theme.colorTheme.hintText),
                  onPressed: () {
                    if (newMessage) {
                      if (_controller.value.text.isEmpty) {
                        widget.onSend("");
                        _controller.clear();
                      } else {
                        widget.onSend(_controller.value.text);
                        _controller.clear();
                      }
                      setState(() {
                        newMessage = false;
                      });
                    }
                  }),
            ),
            // GestureDetector(
            //   onTap: () {
            //     widget.onSend(_controller.value.text);
            //     _controller.clear();
            //   },
            //   child: Icon(CupertinoIcons.paperplane_fill),
            // ),
          ],
        ),
      ),
    );
  }

  Widget chatIcon({required Widget child, VoidCallback? onTap}) {
    var content = Container(
      height: 34,
      width: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: BrandColors.primary, //color != null ? color : BrandColors.blue1,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }

  Future<void> openAttachment(BuildContext context) async {
    final cameraTitle = Text(AppLocalizations.of(context)?.camera ?? '');
    final Function() cameraAction = () async {
      Navigator.pop(context);
      var url = await Camera.takePhoto();
//      debugPrint('setAvatar:  camera:  \nurl = $url  \ninitialValue = ${form.avatar.state.initialValue}  \nvalue = ${form.avatar.state.value}\n');

//      form.avatar.setValue(url);
//      form.trySubmit();
    };
    final photoTitle = Text(AppLocalizations.of(context)?.photo ?? '');
    final Function() photoAction = () async {
      Navigator.pop(context);
//      final ImagePicker _picker = ImagePicker();
      var url = await Gallery.pickPhoto();

      final message = Message(
        text: 'Hello1',
//        attachments: [
//          Attachment(
//            type: 'image',
//            file: AttachmentFile(
//              path: url,
//              size: 306176,
//            ),
//          ),
//        Attachment(
//          type: 'file',
//          file: AttachmentFile(path: 'filePath/fileName.pdf', size: null),
//        ),
//        ],
      );
      await widget.channel.sendMessage(message);
//      debugPrint('setAvatar:  foto:  \nurl = $url  \ninitialValue = ${form.avatar.state.initialValue}  \nvalue = ${form.avatar.state.value}\n');

//      form.avatar.setValue(url);
//      form.trySubmit();
    };

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Attach image
              GestureDetector(
                onTap: () {
                  attachImage();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: CupertinoColors.quaternarySystemFill,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/inactive_gallery.png',
                          height: 10.0,
                          width: 10.0,
                        ),
                      ),
                      Text(AppLocalizations.of(context)?.photo ?? ''),
                    ],
                  ),
                ),
              ),
              // Attach camera photo
              GestureDetector(
                onTap: attachCamera,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          child: Image.asset(
                            'assets/images/camera.png',
                            height: 18.0,
                            width: 18.0,
                            color: Color(0xFF9BB3D4),
                          ),
                        ),
                      ),
                      Text(AppLocalizations.of(context)?.camera ?? ''),
                    ],
                  ),
                ),
              ),
              // Attach files
              GestureDetector(
                onTap: attachFile,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          child: Image.asset(
                            'assets/images/files.png',
                            height: 18.0,
                            width: 18.0,
                          ),
                        ),
                      ),

//                    CircleAvatar(
//                      backgroundColor: ,
//                      child: Image.asset('assets/images/camera.png', fit: BoxFit.scaleDown,),
//                    ),
                      Text(AppLocalizations.of(context)?.file ?? ''),
                    ],
                  ),
                ),
              ),
              // Go back
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Color(0xFF9BB3D4),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(AppLocalizations.of(context)?.cancel ?? ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void attachCamera() async {
    Navigator.pop(context);
    var attachment = Attachment();
    return await checkPermission(() async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
      );
      if (pickedFile != null) {
        var file = File(pickedFile.path);
        debugPrint('camera:  send image to client');
        var client = getIt<ChatService>().client;
        String basename = path.basename(file.path);
        Navigator.of(context).push(
          materialRoute(
            AttachmentPage(
              onSend: (text, fileOn) async {
                int length = await fileOn.length();
                if (length > widget.maxLength) {
                  _showFileLengthAlert();
                } else {
                  var res = await client
                      .sendImage(
                    AttachmentFile(
                      size: length,
                      path: fileOn.path,
                    ),
                    'images',
                    'images',
                  )
                      .then((response) {
                    if (response.file.isNotEmpty) {
                      final imageUrl = response.file;
//                    DefaultCacheManager().downloadFile(imageUrl);
                      DefaultCacheManager().putFile(imageUrl, fileOn.readAsBytesSync());

                      attachment = attachment.copyWith(
                        type: 'image',
                        imageUrl: imageUrl,
                        title: basename,
                      );
                      final message = Message(text: text, attachments: [attachment]);
                      widget.channel.client.sendMessage(
                        message,
                        widget.channel.id!,
                        widget.channel.type,
                      );
                      Navigator.pop(context);
                    }
                  });
                }
              },
              channel: widget.channel,
              isImage: true,
              file: file,
            ),
          ),
        );
      } else {
        return null;
      }
    });
  }

  void attachImage() async {
    Navigator.pop(context);
    var attachment = Attachment();
    return await permitionGallery(() async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
      );
      debugPrint('gallery:  send image:  path = ${pickedFile?.path} }');
      if (pickedFile != null) {
        var file = File(pickedFile.path);
        var client = getIt<ChatService>().client;
        String basename = path.basename(file.path);
        Navigator.of(context).push(
          materialRoute(
            AttachmentPage(
              onSend: (text, fileOn) async {
                int length = await fileOn.length();
                if (length > widget.maxLength) {
                  _showFileLengthAlert();
                } else {
                  var res = await client
                      .sendImage(
                    AttachmentFile(
                      size: length,
                      path: fileOn.path,
                    ),
                    'images',
                    'images',
                  )
                      .then((response) {
                    final imageUrl = response.file;
//                  DefaultCacheManager().downloadFile(imageUrl);
                    DefaultCacheManager().putFile(imageUrl, fileOn.readAsBytesSync());

                    attachment = attachment.copyWith(
                      type: 'image',
                      imageUrl: imageUrl,
                      title: basename,
                    );
                    final message = Message(text: text, attachments: [attachment]);
                    widget.channel.client.sendMessage(
                      message,
                      widget.channel.id!,
                      widget.channel.type,
                    );
                    Navigator.pop(context);
                  });
                }
              },
              channel: widget.channel,
              isImage: true,
              file: file,
            ),
          ),
        );
      } else {
        return null;
      }
    });
  }

  void attachFile() async {
    Navigator.pop(context);
    var attachment = Attachment();
    return await checkStoragePermission(() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        File file = File(
          result.files.single.path!,
        );
        debugPrint('file:  send file to client');
        var client = getIt<ChatService>().client;
        int length = await file.length();
        String basename = path.basename(file.path);
        if (length > widget.maxLength) {
          _showFileLengthAlert();
        } else {
          Navigator.of(context).push(
            materialRoute(
              AttachmentPage(
                onSend: (text, fileOn) async {
                  var res = await client
                      .sendFile(
                    AttachmentFile(size: length, path: fileOn.path),
                    widget.channel.id!,
                    widget.channel.type,
                  )
                      .then(
                        (response) async {
                      if (response.file.isNotEmpty) {
                        final fileUrl = response.file;
                        DefaultCacheManager().downloadFile(
                          fileUrl,
                        );
                        attachment = attachment.copyWith(
                          type: 'file',
                          assetUrl: fileUrl,
                          title: basename,
                        );
                        final message = Message(text: text, attachments: [attachment]);
                        widget.channel.client.sendMessage(
                          message,
                          widget.channel.id!,
                          widget.channel.type,
                        );
                        Navigator.pop(context);
//                      Navigator.of(context).push(materialRoute(
//                        StreamChannel(
//                          channel: widget.channel,
//                          child: ChatPage(),
//                        ),
//                      ));
                      }
                    },
                  );
                },
                channel: widget.channel,
                isImage: false,
                file: file,
              ),
            ),
          );
        }
      } else {
        return null;
      }
    });
  }

  void _showFileLengthAlert() {
    BrandAlert.show(
        context: context,
        title: AppLocalizations.of(context)?.fileLength ?? '',
        subtitle: (AppLocalizations.of(context)?.fileLengthError ?? ''),
        secondaryButtonTitle: null,
        secondaryButtonAction: null,
        mainButtonTitle: 'Ok',
        mainButtonAction: () {
          Navigator.pop(context);
        });
  }

  Future permitionGallery<T>(Future<T> Function() callback) async {
    if (!await Permission.photos.request().isGranted) {
      openAppSettings();
    }
    if (await Permission.photos.request().isGranted) {
      return await callback();
    }
  }

  Future checkPermission<T>(Future<T> Function() callback) async {
//    debugPrint('status = ${await Permission.storage.status}');

    if (!await Permission.camera.request().isGranted) {
      openAppSettings();
    }
    if (await Permission.camera.request().isGranted) {
      return await callback();
    }
  }

  Future checkStoragePermission<T>(Future<T> Function() callback) async {
//    debugPrint('status = ${await Permission.storage.status}');

    if (!await Permission.storage.request().isGranted) {
      openAppSettings();
    }
    if (await Permission.storage.request().isGranted) {
      return await callback();
    }
  }
}

class _AttachmentButton extends StatelessWidget {
  const _AttachmentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            width: 0.5,
            color: BrandColors.grey3,
          ),
        ),
      ),
      width: 34,
      height: 34,
      child: Icon(CupertinoIcons.plus_circle, color: CupertinoColors.secondaryLabel),
    );
  }
}
