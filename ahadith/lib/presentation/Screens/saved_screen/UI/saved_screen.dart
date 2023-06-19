import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final savedCategories = Provider.of<FavoritesAndSavedProvider>(context).savedCategories;
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Text('Saved Screen'),
      ),
    );
  }
}
