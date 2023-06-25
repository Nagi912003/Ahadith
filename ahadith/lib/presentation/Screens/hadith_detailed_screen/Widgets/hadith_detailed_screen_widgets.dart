import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar appbar(BuildContext context, String title) {
  return AppBar(
    title: Text(title, style: Theme.of(context).textTheme.titleLarge),
    // titleSpacing: 20,
    centerTitle: true,
    titleTextStyle: Theme.of(context).textTheme.titleLarge,
  );
}

Widget hadithGrade(String hadithGrade, BuildContext context,
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
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Colors.deepPurple
                      : Colors.deepPurple.shade100,
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
    String title, String content, bool isHadith, BuildContext context) {
  return Card(
    color: isHadith ? Colors.deepPurple.shade100 : Theme.of(context).cardColor,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: RichText(
        textAlign: TextAlign.end,
        text: TextSpan(
          text: title,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
            fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
            fontWeight: FontWeight.bold,
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.deepPurple
                : Colors.deepPurple.shade100,
          ),
          children: [
            TextSpan(
              text: content,
              style: TextStyle(
                fontFamily: isHadith? Theme.of(context).textTheme.bodyLarge?.fontFamily:Theme.of(context).textTheme.bodySmall?.fontFamily,
                fontSize: isHadith ? 18.sp : 19.sp,
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
    String title, Icon icon, onPressed, bool hasText, BuildContext context) {
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
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.deepPurple
              : Colors.deepPurple.shade100,
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
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.deepPurple
                    : Colors.deepPurple.shade100,
              ),
            )
          : icon,
    ),
  );
}

Function showReference(String reference, BuildContext context) {
  return () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'السند',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          reference,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 17.sp,
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
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  };
}

Widget _showSnakeBar(String message, BuildContext context) {
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
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.deepPurple.withOpacity(0.6)
              : Colors.deepPurple.shade100.withOpacity(0.6),
      duration: const Duration(seconds: 2),
    ),
  );
  return Container();
}

Widget snakeBarFavoriteMessage(bool isFavorite, BuildContext context) {
  try {
    return !isFavorite
        ? _showSnakeBar('تمت اضافة الحديث الى المفضلة', context)
        : _showSnakeBar('تمت ازالة الحديث من المفضلة', context);
  } catch (e) {
    print('Error showing Snackbar: $e');
    return Container();
  }
}

Widget snakeBarSavedMessage(bool isSaved, BuildContext context) {
  try {
    return isSaved
        ? _showSnakeBar('تمت اضافة الحديث الى المحفوظات', context)
        : _showSnakeBar('تمت ازالة الحديث من المحفوظات', context);
  } catch (e) {
    print('Error showing Snackbar: $e');
    return Container();
  }
}

Icon favoriteIcon(bool isFavorite, BuildContext context) {
  return Icon(
    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
    color: MediaQuery.of(context).platformBrightness == Brightness.light
        ? Colors.deepPurple
        : Colors.deepPurple.shade100,
    size: 30.sp,
  );
}

Icon saveIcon(bool isSaved, BuildContext context) {
  return Icon(
    isSaved ? Icons.save : Icons.save_alt_outlined,
    color: MediaQuery.of(context).platformBrightness == Brightness.light
        ? Colors.deepPurple
        : Colors.deepPurple.shade100,
    size: 30.sp,
  );
}
