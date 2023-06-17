import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar appbar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    // titleSpacing: 20,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget hadithGrade(String hadithGrade) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text(
        hadithGrade,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.normal,
          color: Colors.deepPurple,
          overflow: TextOverflow.clip,
        ),
      ),
      Text(
        ' حديث',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    ],
  );
}

Widget buildCard(String title, String content, bool isHadith) {
  return Card(
    color: isHadith ? null : Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: RichText(
        textAlign: TextAlign.end,
        text: TextSpan(
          text: title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
          children: [
            TextSpan(
              text: content,
              style: TextStyle(
                fontSize: isHadith ? 18.sp : 19.sp,
                fontWeight: isHadith ? FontWeight.bold : FontWeight.normal,
                color: isHadith ? Colors.black : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildButton(String title, Icon icon, onPressed, bool hasText) {
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
          border: Border.all(color: Colors.deepPurple, width: 1)),
      child: hasText
          ? Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, color: Colors.black87),
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

Widget  _showSnakeBar(String message, BuildContext context) {
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
        backgroundColor: Colors.deepPurple.withOpacity(0.6),
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
        ? _showSnakeBar('تمت اضافة الحديث الى المحفوظات',context)
        : _showSnakeBar('تمت ازالة الحديث من المحفوظات',context);
  } catch (e) {
    print('Error showing Snackbar: $e');
    return Container();
  }
}

Icon favoriteIcon(bool isFavorite) {
  return Icon(
    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
    color: Colors.deepPurple,
    size: 30.sp,
  );
}

Icon saveIcon(bool isSaved) {
  return Icon(
    isSaved ? Icons.save : Icons.save_alt_outlined,
    color: Colors.deepPurple,
    size: 30.sp,
  );
}