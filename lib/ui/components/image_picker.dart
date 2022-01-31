import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/forms/profile/profile.dart';
import 'package:sputnik/logic/locators/chat.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/ui/helpers/phone_services/camera/camera.dart';
import 'package:sputnik/ui/helpers/phone_services/gallery/gallery.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
enum ImageType { avatar, image }

class ImagePicker {

  static Widget get cameraTitle => Text(AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.camera ?? '');

  static Widget get photoTitle => Text(AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.photo ?? '');

  static Widget get cancelTitle => Text(AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.cancel ?? '');

  static void cameraAction(BuildContext context, ProfileFormCubit form, ImageType imageType) async {
    Navigator.pop(context);
    var url = await Camera.takePhoto();
    debugPrint('setAvatar:  camera:  \nurl = $url  \ninitialValue = ${form.avatar.state.initialValue}  \nvalue = ${form.avatar.state.value}\n');
    await cropImage(url, form, imageType);
    //form.trySubmit();

    debugPrint('setAvatar:  camera:  \nurl = $url  \ninitialValue = ${form.avatar.state.initialValue}  \nvalue = ${form.avatar.state.value}\n');
  }

  static void photoAction(BuildContext context, ProfileFormCubit form, ImageType imageType) async {
    Navigator.pop(context);
    var url = await Gallery.pickPhoto();
    debugPrint('setAvatar:  foto:  \nurl = $url  \ninitialValue = ${form.avatar.state.initialValue}  \nvalue = ${form.avatar.state.value}\n');
    await cropImage(url, form, imageType);
   // form.avatar.setValue(url);
   // form.trySubmit();
    //form.trySubmit();

    debugPrint('setAvatar:  foto:  \nurl = $url  \ninitialValue = ${form.avatar.state.initialValue}  \nvalue = ${form.avatar.state.value}\n');
  }

  static Future<void> show(BuildContext context, ProfileFormCubit form, [ImageType imageType = ImageType.image]) async {
    if (Platform.isAndroid) {
      showModalBottomSheet(
          context: context,
          builder: (ctx) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: cameraTitle,
                    onTap: () => cameraAction(ctx, form , imageType),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: photoTitle,
                    onTap: () => photoAction(ctx, form, imageType),
                  ),
                  ListTile(
                    //leading: new Icon(Icons.share),
                    title: cancelTitle,
                    onTap: () => Navigator.pop(ctx),
                  ),
                ],
              ));
    } else if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (ctx) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () => cameraAction(ctx, form, imageType),
                    child: cameraTitle,
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () => photoAction(ctx, form, imageType),
                    child: photoTitle,
                  )
                ],
                cancelButton: CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(ctx),
                  child: cancelTitle,
                ),
              ));
    }
  }

  static Future<String> cropImage(String filePath, ProfileFormCubit form, ImageType imageType) async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: filePath,
      cropStyle: imageType == ImageType.image ? CropStyle.rectangle : CropStyle.circle,
      aspectRatioPresets: imageType == ImageType.avatar ? [CropAspectRatioPreset.square] : Platform.isAndroid
          ? [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9,
            ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.edit ?? '',
        toolbarColor: BrandColors.primary,
        activeControlsWidgetColor: BrandColors.primary,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.edit ?? '',
      ),
    );
    if (croppedFile != null) {
      var url = await _uploadImage(croppedFile);
      form.avatar.setValue(url);
      return url;
    }
    return "";
  }

  static Future _uploadImage(File imageFile) async {
    debugPrint('gallery:  send image to client');
    var client = getIt<ChatService>().client;
    int length = await imageFile.length();
    var res = await client.sendImage(
      AttachmentFile(size: length, path: imageFile.path), 'images', 'images',
    );
    return res.file;
  }
 }
