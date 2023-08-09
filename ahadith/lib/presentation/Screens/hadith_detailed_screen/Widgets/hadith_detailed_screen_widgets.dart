import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theme/theme_manager.dart';

AppBar appbar(BuildContext context, String title, ThemeManager themeManager) {
  return AppBar(
    foregroundColor: themeManager.appPrimaryColor200,
    title: Text(title, style: Theme.of(context).textTheme.titleLarge),
    // titleSpacing: 20,
    centerTitle: true,
    titleTextStyle: Theme.of(context).textTheme.titleLarge,
    actions: [SizedBox(width: 10.w)],
  );
}

Widget hadithGrade(String hadithGrade, BuildContext context, ThemeManager themeManager,
    {bool fullScreen = true}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: fullScreen? 300.w: 200.w,
          child: Text(
            hadithGrade,
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
              color: themeManager.appPrimaryColor200,
              overflow: TextOverflow.clip,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        Text(
          ' حديث',
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    ),
  );
}

Widget buildCard(
    String title, String content, bool isHadith, BuildContext context, ThemeManager themeManager) {
  return Card(
    color: isHadith ? themeManager.appPrimaryColor200 : Theme.of(context).cardColor,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: RichText(
        textAlign: TextAlign.end,
        text: TextSpan(
          text: title,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize! + themeManager.fontSize,
            fontWeight: FontWeight.bold,
            color: themeManager.appPrimaryColor200,
          ),
          children: [
            TextSpan(
              text: content,
              style: TextStyle(
                fontFamily: isHadith? Theme.of(context).textTheme.bodyLarge?.fontFamily:Theme.of(context).textTheme.bodySmall?.fontFamily,
                fontSize: isHadith ? 18.sp + themeManager.fontSize : 19.sp + themeManager.fontSize,
                fontWeight: isHadith ? FontWeight.bold : FontWeight.normal,
                color: isHadith
                    ? Colors.black
                    : Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color, //isHadith ? Colors.black : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildButton(
    String title, Icon icon, onPressed, bool hasText, BuildContext context,  ThemeManager themeManager) {
  return MaterialButton(
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    child: Container(
      width: hasText ? 150.w : 80.w,
      height: 40.h,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: themeManager.appPrimaryColor200,
          width: 1,
        ),
      ),
      child: hasText
          ? Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontFamily: Theme.of(context).textTheme.titleLarge?.fontFamily,
                color: themeManager.appPrimaryColor200,
              ),
            )
          : icon,
    ),
  );
}

Function showReference(String reference, BuildContext context, ThemeManager themeManager) {
  return () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'المراجع',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: themeManager.appPrimaryColor,
            fontSize: 25.sp + themeManager.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          reference,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 17.sp + themeManager.fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'حسناً',
              style: TextStyle(
                fontSize: 20.sp + themeManager.fontSize,
                fontWeight: FontWeight.bold,
                color: themeManager.appPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  };
}

Widget _showSnakeBar(String message, BuildContext context, ThemeManager themeManager) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: themeManager.appPrimaryColor200.withOpacity(0.6),
      duration: const Duration(seconds: 2),
    ),
  );
  return Container();
}

Widget snakeBarFavoriteMessage(bool isFavorite, BuildContext context, ThemeManager themeManager) {
  try {
    return !isFavorite
        ? _showSnakeBar('تمت اضافة الحديث الى المفضلة', context, themeManager)
        : _showSnakeBar('تمت ازالة الحديث من المفضلة', context, themeManager);
  } catch (e) {
    print('Error showing Snackbar: $e');
    return Container();
  }
}

Widget snakeBarSavedMessage(bool isSaved, BuildContext context, ThemeManager themeManager) {
  try {
    return isSaved
        ? _showSnakeBar('تمت اضافة الحديث الى المحفوظات', context, themeManager)
        : _showSnakeBar('تمت ازالة الحديث من المحفوظات', context, themeManager);
  } catch (e) {
    print('Error showing Snackbar: $e');
    return Container();
  }
}

Icon favoriteIcon(bool isFavorite, BuildContext context,  ThemeManager themeManager) {
  return Icon(
    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
    color: themeManager.appPrimaryColor200,
    size: 30.sp,
  );
}

Icon saveIcon(bool isSaved, BuildContext context, ThemeManager themeManager) {
  return Icon(
    isSaved ? Icons.save : Icons.save_alt_outlined,
    color: themeManager.appPrimaryColor200,
    size: 30.sp,
  );
}
