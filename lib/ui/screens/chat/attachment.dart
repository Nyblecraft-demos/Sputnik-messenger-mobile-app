import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/ui/components/bottom_chat_bar/bottom_chat_bar.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/brand_edit_button/brand_edit_button.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:path/path.dart' as path;

class AttachmentPage extends StatefulWidget {
  @override
  _AttachmentPageState createState() => _AttachmentPageState();

  const AttachmentPage({
    Key? key,
    required this.onSend,
    required this.channel,
    required this.isImage,
    required this.file,
  }) : super(key: key);

  final Future<void> Function(String text, File file) onSend;
  final Channel channel;
  final bool isImage;
  final File file;
}

class _AttachmentPageState extends State<AttachmentPage> {
  String basename = "";
  bool isLoading = false;
  late File localFile;

  @override
  void initState() {
    super.initState();
    basename = path.basename(widget.file.path);
    localFile = widget.file;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: AppBar(
            leading: BrandBackButton(),
            actions: [
              BrandEditButton(
                onPressed: _cropImage,
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isImage)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                _cropImage();
                              },
                              child: Center(
                                child: Image.file(
                                  localFile,
//                              fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            if (isLoading)
                              Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  backgroundColor: BrandColors.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
//                      Text(
//                        basename,
//                        softWrap: true,
//                        maxLines: 1,
//                        overflow: TextOverflow.ellipsis,
//                        textAlign: TextAlign.center,
//                      ),
                    ],
                  ),
                ),
              if (!widget.isImage)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.insert_drive_file_rounded,
                        color: Color(0xFF9BB3D4),
                        size: 45,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          basename,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
//                      if(isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(isLoading ? Color(0xFF9BB3D4) : Colors.transparent),
                          backgroundColor: isLoading ? Colors.white : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              BottomChatBar(
                onSend: (
                  text,
                ) async {
                  setState(() {
                    isLoading = true;
                  });
                  var res = await widget.onSend(text, localFile);
                  isLoading = false;
                },
                channel: widget.channel,
                showAttachment: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: localFile.path,
      aspectRatioPresets: Platform.isAndroid ? [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9] : [CropAspectRatioPreset.original, CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio5x3, CropAspectRatioPreset.ratio5x4, CropAspectRatioPreset.ratio7x5, CropAspectRatioPreset.ratio16x9],
      androidUiSettings: AndroidUiSettings(toolbarTitle: 'Cropper', toolbarColor: BrandColors.primary, activeControlsWidgetColor: BrandColors.primary, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ),
    );
    if (croppedFile != null) {
      setState(() {
        localFile = croppedFile;
//        state = AppState.cropped;
      });
    }
  }
}
