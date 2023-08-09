import 'dart:io';

import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import 'package:ahadith/presentation/Screens/favorites_screen/widgets/favorite_hadith.dart';
import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../favorites_screen/widgets/blurred_container.dart';
import '../../favorites_screen/widgets/captured_widget.dart';

class RandomHadith extends StatelessWidget {
  const RandomHadith({super.key, required this.themeManager});
  final ThemeManager themeManager;
  @override
  Widget build(BuildContext context) {
  ScreenshotController screenshotController = ScreenshotController();
    void _takeScreenshot(hadith, hadithIndex, pixelRatio) async {
      var takenWidget = Stack(
        children: [
          BlurredContainer(
            child: SizedBox(
              // color: Colors.black,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                themeManager.bgImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          CapturedWidget(
            hadith: hadith,
            hadithIndex: hadithIndex,
            context: context,
            isRandom: true,
            themeManager: themeManager,
          ),
        ],
      );
      await screenshotController
          .captureFromWidget(
        // pixelRatio: pixelRatio,
          InheritedTheme.captureAll(context, Material(child: takenWidget)),
          delay: const Duration(seconds: 1))
          .then((image) async {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFiles([imagePath.path], text: '#حديـث اليوم \n #صل_على_محمد');
        // ShowCapturedWidget(context, image);
      });
    }

    final hadith = Provider.of<FavoritesAndSavedProvider>(context).randomHadith;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FavoriteHadith(hadith: hadith, hadithIndex: 'حديث اليوم',isRandom: true,themeManager: themeManager),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            onPressed: () {
              _takeScreenshot(hadith,
                  'حديث اليوم', MediaQuery.of(context).devicePixelRatio);
            },
            icon: Icon(
              Icons.share_outlined,
              size: 35.w,
              color: themeManager.appPrimaryColor200,
            ),
          ),
        )
      ],
    );
  }

}
