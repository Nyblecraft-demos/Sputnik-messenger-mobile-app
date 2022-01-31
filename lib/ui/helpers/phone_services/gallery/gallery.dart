import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class Gallery {
  static Future<String> pickPhoto() async {
    return await _permitionGallery(() async {
      debugPrint('gallery:  open picker');
      final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: 800,
          maxWidth: 800);
      debugPrint('gallery:  send image:  path = ${pickedFile?.path} }');
      if (pickedFile != null) {
        var file = File(pickedFile.path);
//         debugPrint('gallery:  send image to client');
//         var client = getIt<ChatService>().client;
//          print(pickedFile.path);
//         int length = await file.length();
//         var res = await client.sendImage(
//           AttachmentFile(size: length, path: pickedFile.path), 'images', 'images',
//         );
        debugPrint('gallery:  send image:  file = $pickedFile  path = ${pickedFile.path}  size = ${file.lengthSync()}');
        return pickedFile.path;
      } else {
        return null;
      }
    });
  }

  static Future<String> attachPhoto() async {
    return await _permitionGallery(() async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
      );
      debugPrint('gallery:  send image:  path = ${pickedFile?.path} }');
      if (pickedFile != null) {
        var file = File(pickedFile.path);
        debugPrint('gallery:  send image to client');
        var client = getIt<ChatService>().client;
//        print(pickedFile.path);
        int leng = await file.length();
        var res = await client.sendImage(
          AttachmentFile(size: leng, path: pickedFile.path), 'images', 'images',
        );
        debugPrint('gallery:  send image:  file = ${res.file}  path = ${pickedFile.path}  size = ${file.lengthSync()}');
        return res.file;
      } else {
        return null;
      }
    });
  }

  static Future _permitionGallery<T>(Future<T> Function() callback) async {
    debugPrint('gallery status = ${await Permission.photos.status}');

    if (!await Permission.photos.request().isGranted) {
      openAppSettings();
    }
    if (await Permission.photos.request().isGranted) {
      return await callback();
    }
  }
}
