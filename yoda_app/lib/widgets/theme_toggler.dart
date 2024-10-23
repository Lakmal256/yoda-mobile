import 'package:flutter/material.dart';
import 'package:yoda_app/locator.dart';
import 'package:yoda_app/theme/provider.dart';
import 'package:yoda_app/theme/theme.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: locate<AppTheme>(),
      builder: (context, theme, _) {
        if (theme.brightness == Brightness.dark) {
          return IconButton(
            onPressed: () => locate<AppTheme>().setTheme(lightTheme),
            icon: const Icon(Icons.light_mode_rounded),
          );
        }

        return IconButton(
          onPressed: () => locate<AppTheme>().setTheme(darkTheme),
          icon: const Icon(Icons.dark_mode_outlined),
        );
      },
    );
  }
}
