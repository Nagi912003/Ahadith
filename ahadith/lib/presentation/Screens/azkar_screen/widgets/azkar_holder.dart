import 'package:flutter/material.dart';

import 'zekr_holder.dart';

Widget AzkarHolder(context,String title,List azkar, color){
  return ExpansionTile(
    title: Text(title),
    childrenPadding: const EdgeInsets.all(8.0),
    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
    iconColor: color,
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: ListView(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            ...azkar.map((e) => zekrHolder(e, color)).toList(),
          ],
        ),
      ),
    ],
  );
}