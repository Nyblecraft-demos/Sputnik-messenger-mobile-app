import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../brand_snackBar.dart';

class ImagePage extends StatelessWidget {
  ImagePage({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;
  final dio = Dio();
  var isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.appTitle ?? ''),
          leading: BrandBackButton(),
          actions: [
            IconButton(
              icon: Icon(Icons.save, color: Colors.white),
              onPressed: () async {
                if (!isSaving) {
                  await _saveImage();
                }
              },
            ),

          ],
        ),
        body: Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(),
                   imageBuilder: (context, imageProvider) => Container(
                     decoration: BoxDecoration(
                       image: DecorationImage(
                           image: imageProvider,
                           fit: BoxFit.fitWidth,),
                     ),
                   ),
                ),
              ),
            ),
    );
  }

  Future _saveImage() async {
    isSaving = true;
    var response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 100);
    print(result);
    const delay = 300;
    final context = getIt.get<NavigationService>().navigatorKey.currentContext;
    if (context != null) {
      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            snackBar(
                text: AppLocalizations.of(context)?.saveImage ?? '',
                durationMS: delay,
                error: false)
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            snackBar(
                text: AppLocalizations.of(context)?.saveImageError ?? '',
                durationMS: delay,
                error: true)
        );
      }
      isSaving = false;
    }
  }

}
