import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/category.dart';

import '../../../../constants/strings.dart';
import '../../../../theme/theme_manager.dart';

Widget buildNoInternetWidget(context) {
  return Center(
    child: Container(
      width: 0.9.sw,
      height: 0.5.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MediaQuery.of(context).size.width>500? Image.asset("assets/images/undraw_connected_world_wuay-removebg-preview.png",
              width: 0.5.sw, height: 0.2.sh): Image.asset("assets/images/undraw_connected_world_wuay-removebg-preview.png"),
          const Text(
            //"can't connect .. check the internet",
            "...حدث مشكلة في الاتصال",
            style: TextStyle(
              fontSize: 22,
              color: Colors.deepPurple,
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
