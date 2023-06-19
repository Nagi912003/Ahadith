import 'package:ahadith/presentation/Screens/hadith_detailed_screen/Widgets/hadith_detailed_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/category.dart';

import '../../../../constants/strings.dart';

Widget buildNoInternetWidget(context) {
  void goToSaved() {
    Navigator.of(context).pushNamed(savedScreen);
  }
  return Center(
    child: Container(
      width: 0.9.sw,
      height: 0.5.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.deepPurple,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/undraw_connected_world_wuay.png"),
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
          buildButton('المحفوظات', const Icon(Icons.save), goToSaved , true, context)
        ],
      ),
    ),
  );
}

Widget categoryItem(Category category, BuildContext context) {
  return Card(
    child: ListTile(
      title:
          Text(category.title!, style: Theme.of(context).textTheme.bodySmall),
      onTap: () {
        Navigator.of(context).pushNamed(
          ahadithScreen,
          arguments: category,
        );
      },
    ),
  );
}
