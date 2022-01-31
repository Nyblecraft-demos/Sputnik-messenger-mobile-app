import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class Camera {
  static Future<String> takePhoto() async {
    return await checkPermission(() async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
      );
      debugPrint('camera:  send image:  path = ${pickedFile?.path} }');
      if (pickedFile != null) {
        // var file = File(pickedFile.path);
        // debugPrint('camera:  send image to client');
        // var client = getIt<ChatService>().client;
        // var res = await client.sendImage(AttachmentFile(size: file.lengthSync(), path: pickedFile.path), 'images', 'images');
        // debugPrint('camera:  send image:  file = ${res.file}  path = ${pickedFile.path}  size = ${file.lengthSync()}');
        return pickedFile.path;
      } else {
        return null;
      }
    });
  }

  static Future<SendImageResponse> attachCameraPhoto() async {
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
        int length = await file.length();
        var res = await client
            .sendImage(
          AttachmentFile(size: length, path: pickedFile.path),
          'images',
          'images',
        )
            .then((response) {
          return response;
        });
      } else {
        return null;
      }
    });
  }

  static Future checkPermission<T>(Future<T> Function() callback) async {
    debugPrint('camera status = ${await Permission.camera.status}');

    if (!await Permission.camera.request().isGranted) {
      openAppSettings();
    }
    if (await Permission.camera.request().isGranted) {
      return await callback();
    }
  }
}
