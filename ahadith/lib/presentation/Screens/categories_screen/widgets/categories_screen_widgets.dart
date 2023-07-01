import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/category.dart';

import '../../../../constants/strings.dart';
import '../../../../theme/theme_manager.dart';

Widget buildNoInternetWidget(context, ThemeManager themeManager) {
  return Center(
    child: Container(
      width: 0.9.sw,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "...حدث مشكلة في الاتصال",
            style: TextStyle(
              fontSize: 22,
              color: themeManager.appPrimaryColor,
              //color: MyColors.mySecondary,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    ),
  );
}

Widget categoryItem(Category category, BuildContext context, ThemeManager themeManager) {
  return Card(
    color: Theme.of(context).cardColor,
    child: ListTile(
      title:
          Text(category.title!, style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.end,),
      onTap: () {
        Navigator.of(context).pushNamed(
          ahadithScreen,
          arguments: {'category':category, 'themeManager':themeManager},
        );
      },
    ),
  );
}
