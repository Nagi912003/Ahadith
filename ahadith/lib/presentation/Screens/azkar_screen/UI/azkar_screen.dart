import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';

import '../../../../constants/azkar.dart';
import '../widgets/azkar_holder.dart';



class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key, required this.themeManager});
  final ThemeManager themeManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أذكار'),
        centerTitle: true,
        foregroundColor: themeManager.appPrimaryColor,
        // backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AzkarHolder(context,'أذكار عامة',azkar, themeManager.appPrimaryColor),
            AzkarHolder(context,'أذكار الصباح',azkarMorning, themeManager.appPrimaryColor),
            AzkarHolder(context,'أذكار المساء',azkarNight, themeManager.appPrimaryColor),
            AzkarHolder(context,'أذكار النوم',azkarSleeping, themeManager.appPrimaryColor),
            AzkarHolder(context,'أذكار الاستيقاظ',azkarWakingUp, themeManager.appPrimaryColor),
            AzkarHolder(context,'أسماء الله الحسنى',AllahNames, themeManager.appPrimaryColor),
          ],
        ),
      ),
    );
  }
}
