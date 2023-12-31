import 'package:flutter/material.dart';

Widget zekrHolder(String zekr, color, context) {
  return Container(
    margin: const EdgeInsets.all(8.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      // color: Colors.green[100],
      border: Border.all(
        color: color,
        width: 2,
      ),
    ),
    child: Text(
      zekr,
      style: TextStyle(fontSize: 20, fontFamily: Theme.of(context).textTheme.bodySmall!.fontFamily),
      textAlign: TextAlign.end,
    ),
  );
}