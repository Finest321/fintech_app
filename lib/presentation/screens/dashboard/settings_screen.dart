import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/cubits/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(
        child: SwitchListTile(
          title: Text("Dark Mode"),
          value: theme == AppTheme.dark,
          onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
        ),
      ),
    );
  }
}
